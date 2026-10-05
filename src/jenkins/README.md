# Jenkins controller

The Kustomize configuration in this directory is the single source of truth.
It deploys one Jenkins 2.580.1 controller on Java 21, a 10 GiB `standard` PVC,
and a ClusterIP service. Deployment updates use `Recreate`, so two controllers
never intentionally write to one home directory during a rollout.

The setup wizard stays enabled. There is no committed administrator password,
privileged permission-fixing container, Ingress, or cluster-wide RBAC.
The controller does not receive a Kubernetes service-account token or Docker socket.

## First setup

Deploy the complete lab using the root instructions, forward port 8081 to the
service, retrieve the initial unlock password, and complete the wizard as described
in [Manual.md](../../Manual.md).

## Optional Jenkins pipeline

GitHub Actions provides automatic tests, integration deployment and image publishing.
The root `Jenkinsfile` is an alternative for a locally managed Jenkins build agent:

1. Install the Pipeline and Git plugins using the plugin manager.
2. Add a trusted external agent labeled `mykubeapp`. Install Git, Python 3.12,
   JDK 21, Docker, kind v0.33.0, kubectl v1.35.8 and curl on that agent.
   Its account must have permission to use its own Docker daemon.
3. Create a Pipeline job from SCM pointing to this repository and `Jenkinsfile`.
4. Builds test both applications and build commit-tagged images.
   Select `DEPLOY_LOCAL` to create/update the dedicated `mykubeapp-build` cluster
   on that agent and run the HTTP smoke tests.

Use a dedicated agent account and cluster. The Jenkins controller pod itself is
not a build agent and cannot create clusters. This keeps Docker privileges off
the controller. Agent/job creation is an explicit initial setup step.

For old PVCs and backup requirements, see the migration section in Manual.md.
