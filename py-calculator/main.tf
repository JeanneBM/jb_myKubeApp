## to add /n for multi-line string or EOF heredoc

resource "local_file" "py_python" {
  filename  = "./app.py"
  content  = "from flask import Flask, render_template, request

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
    app.run()"
}

resource "local_file" "py_html" {
  filename     = "./templetes/app.html"
  content  = "<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title></title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/skeleton/2.0.4/skeleton.min.css"
    />

    <style>
      .alert {
        background: blue;
        padding: 1rem;
        border-radius: 5px;
        color: white;
        margin: 1rem;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h3>PyCalculator</h3>
    </div>

    <!-- Form -->
    <div class="container">
      <form action="/calculations" method="POST">
        <label for="Number One">Enter the first number: </label>
        <input
          type="number"
          placeholder="First Number"
          class="u-full-width"
          name="x"
        />

        <label for="Number Two">Enter the second number: </label>
        <input
          type="number"
          placeholder="Second Number"
          class="u-full-width"
          name="y"
        />

        <label for="Operation">What kind of operation should be performed?</label>
        <select class="u-full-width" name="operation">
          <option value="addition">Addition</option>
          <option value="subtraction">Subtraction</option>
          <option value="multiplication">Multiplication</option>
          <option value="division">Division</option>
        </select>

        <input type="submit" value="Perform" id="calc_btn" />
        <br />
        <div class="alert">
          {{ sum }}
        </div>
      </form>
    </div>
  </body>
</html>"
}

resource "local_file" "requirements" {
  filename     = "./requirements.txt"
  content  = "black==21.5b1/nclick==7.1.2/nFlask==1.1.2/nitsdangerous==1.1.0/nJinja2==2.11.3/nMarkupSafe==1.1.1/nWerkzeug==1.0.1"
}

resource "local_file" "requirements1" {
  filename     = "./requirements1.txt"
  content  = <<-EOF
black==21.5b1click==7.1.2
Flask==1.1.2
itsdangerous==1.1.0
Jinja2==2.11.3
MarkupSafe==1.1.1
Werkzeug==1.0.1
EOF
}
