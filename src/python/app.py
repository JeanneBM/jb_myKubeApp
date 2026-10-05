import math
import operator

from flask import Flask, render_template, request

app = Flask(__name__)


@app.route('/')
def main():
    return render_template('app.html')


@app.get('/healthz')
def health():
    return {'status': 'ok'}


@app.post('/calculations')
def calculate():
    operations = {
        'addition': operator.add,
        'subtraction': operator.sub,
        'multiplication': operator.mul,
        'division': operator.truediv,
    }
    try:
        x = float(request.form.get('x', ''))
        y = float(request.form.get('y', ''))
    except (ValueError, TypeError, OverflowError):
        return render_template('app.html', error='Enter two valid numbers.'), 400

    operation = request.form.get('operation')
    if not all(math.isfinite(value) for value in (x, y)):
        return render_template('app.html', error='Numbers must be finite.'), 400
    if operation not in operations:
        return render_template('app.html', error='Choose a valid operation.'), 400
    if operation == 'division' and y == 0:
        return render_template('app.html', error='Cannot divide by zero.'), 400

    result = operations[operation](x, y)
    if not math.isfinite(result):
        return render_template('app.html', error='Result is outside the supported range.'), 400
    return render_template('app.html', result=result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
