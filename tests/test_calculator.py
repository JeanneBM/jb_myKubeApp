import pytest

from app import app


@pytest.fixture
def client():
    app.config.update(TESTING=True)
    return app.test_client()


def test_home_and_health(client):
    assert b'PyCalculator' in client.get('/').data
    assert client.get('/healthz').json == {'status': 'ok'}


@pytest.mark.parametrize('operation,x,y,result', [
    ('addition', '2.5', '3', '5.5'),
    ('subtraction', '2', '3', '-1.0'),
    ('multiplication', '-2', '3', '-6.0'),
    ('division', '7', '2', '3.5'),
    ('subtraction', '3', '3', '0.0'),
])
def test_calculations(client, operation, x, y, result):
    response = client.post('/calculations', data={'x': x, 'y': y, 'operation': operation})
    assert response.status_code == 200
    assert f'>{result}</div>'.encode() in response.data


@pytest.mark.parametrize('data,message', [
    ({}, 'Enter two valid numbers.'),
    ({'x': '', 'y': '1', 'operation': 'addition'}, 'Enter two valid numbers.'),
    ({'x': 'abc', 'y': '1', 'operation': 'addition'}, 'Enter two valid numbers.'),
    ({'x': '1', 'y': '0', 'operation': 'division'}, 'Cannot divide by zero.'),
    ({'x': '1', 'y': '-0', 'operation': 'division'}, 'Cannot divide by zero.'),
    ({'x': '1', 'y': '2', 'operation': 'unknown'}, 'Choose a valid operation.'),
    ({'x': '1', 'y': '2'}, 'Choose a valid operation.'),
    ({'x': 'nan', 'y': '2', 'operation': 'addition'}, 'Numbers must be finite.'),
    ({'x': 'inf', 'y': '2', 'operation': 'addition'}, 'Numbers must be finite.'),
    ({'x': '1e308', 'y': '1e308', 'operation': 'multiplication'}, 'Result is outside the supported range.'),
])
def test_invalid_input_is_a_client_error(client, data, message):
    response = client.post('/calculations', data=data)
    assert response.status_code == 400
    assert message.encode() in response.data


def test_calculations_requires_post(client):
    assert client.get('/calculations').status_code == 405
