from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]


def resources(directory):
    config = yaml.safe_load((directory / 'kustomization.yaml').read_text())
    result = []
    for item in config['resources']:
        path = directory / item
        if path.is_dir():
            result.extend(resources(path))
        else:
            result.extend(doc for doc in yaml.safe_load_all(path.read_text()) if doc)
    return result


def test_workloads_and_services_are_connected():
    docs = resources(ROOT / 'k8s')
    namespaces = {doc['metadata']['name'] for doc in docs if doc['kind'] == 'Namespace'}
    identities = [(doc['kind'], doc['metadata'].get('namespace'), doc['metadata']['name']) for doc in docs]
    assert len(identities) == len(set(identities)), 'Duplicate Kubernetes objects'
    deployments = [doc for doc in docs if doc['kind'] == 'Deployment']
    assert len(deployments) == 3
    for doc in docs:
        if doc['kind'] != 'Namespace':
            assert doc['metadata']['namespace'] in namespaces
    for service in (doc for doc in docs if doc['kind'] == 'Service'):
        matches = [dep for dep in deployments
                   if dep['metadata']['namespace'] == service['metadata']['namespace']
                   and all(dep['spec']['template']['metadata']['labels'].get(key) == value
                           for key, value in service['spec']['selector'].items())]
        assert len(matches) == 1
        ports = matches[0]['spec']['template']['spec']['containers'][0]['ports']
        for port in service['spec']['ports']:
            assert port['targetPort'] in {item['name'] for item in ports}
    for dep in deployments:
        container = dep['spec']['template']['spec']['containers'][0]
        assert all(probe in container for probe in ('startupProbe', 'readinessProbe', 'livenessProbe'))
        assert container['resources']['requests'] and container['resources']['limits']


def test_jenkins_has_one_controller_and_a_bound_storage_class():
    docs = resources(ROOT / 'k8s')
    jenkins = next(doc for doc in docs if doc['kind'] == 'Deployment' and doc['metadata']['name'] == 'jenkins')
    assert jenkins['spec']['replicas'] == 1
    assert jenkins['spec']['strategy']['type'] == 'Recreate'
    pod = jenkins['spec']['template']['spec']
    assert not pod.get('initContainers')
    pvc = next(doc for doc in docs if doc['kind'] == 'PersistentVolumeClaim')
    assert pod['volumes'][0]['persistentVolumeClaim']['claimName'] == pvc['metadata']['name']
    assert pvc['spec']['storageClassName'] == 'standard'
