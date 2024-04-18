from flask import Flask, render_template, request

app = Flask(__name__)


@app.route('/')
def main():
    return render_template('app.html')


@app.route('/calculations', methods=['POST'])
def send(sum=sum):
    if request.method == 'POST':
        x = request.form['x']
        y = request.form['y']
        operation = request.form['operation']

        if operation == 'addition':
            sum = float(x) + float(y)
            return render_template('app.html', sum=sum)

        elif operation == 'subtraction':
            sum = float(x) - float(y)
            return render_template('app.html', sum=sum)

        elif operation == 'multiplication':
            sum = float(x) * float(y)
            return render_template('app.html', sum=sum)

        elif operation == 'division':
            sum = float(x) / float(y)
            return render_template('app.html', sum=sum)
        else:
            return render_template('app.html')


if __name__ == ' __main__':
    app.debug = True
    app.run()
