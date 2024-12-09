import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  bool _isDecimalAdded = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '0';
        _isDecimalAdded = false;
      } else if (buttonText == 'X') {
        if (_expression.isNotEmpty) {
          if (_expression.endsWith('.')) {
            _isDecimalAdded = false;
          }
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = NumberFormat("#.##########", "en_US").format(eval);
          _expression = _result;
          _isDecimalAdded = _expression.contains('.');
        } catch (e) {
          _result = 'Ошибка выражения';
        }
      } else if (buttonText == '.') {
        if (_expression.isEmpty) {
          _expression = '0.';
          _isDecimalAdded = true;
        } else if (_isOperator(_expression[_expression.length - 1])) {
          _expression += '0.';
          _isDecimalAdded = true;
        } else if (!_isDecimalAdded) {
          _expression += buttonText;
          _isDecimalAdded = true;
        }
      } else if (buttonText == '√') {
        if (_expression.isNotEmpty) {
          try {
            double num = double.parse(_expression);
            double sqrtResult = sqrt(num);
            _result = NumberFormat("#.##########", "en_US").format(sqrtResult);
            _expression = _result;
            _isDecimalAdded = _expression.contains('.');
          } catch (e) {
            _result = 'Ошибка выражения';
          }
        }
      } else {
        if (_isOperator(buttonText)) {
          if (_expression.isEmpty) return;

          String lastChar = _expression[_expression.length - 1];

          if (_isOperator(lastChar)) {
            if (buttonText == '-' && lastChar != '-') {
              _expression += buttonText;
            } else {
              _expression =
                  _expression.substring(0, _expression.length - 1) + buttonText;
            }
            return;
          }

          _isDecimalAdded = false;
          _expression += buttonText;
        } else {
          _expression += buttonText;
        }
      }
    });
  }

  bool _isOperator(String buttonText) {
    return buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '*' ||
        buttonText == '/' ||
        buttonText == '^';
  }

  Widget _buildButton(String buttonText, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          padding: EdgeInsets.all(24.0),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Калькулятор')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _expression,
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton('C', Colors.orange),
                _buildButton('.', Colors.orange),
                _buildButton('X', Colors.orange),
                _buildButton('/', Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton('7', Colors.white),
                _buildButton('8', Colors.white),
                _buildButton('9', Colors.white),
                _buildButton('*', Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton('4', Colors.white),
                _buildButton('5', Colors.white),
                _buildButton('6', Colors.white),
                _buildButton('-', Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton('1', Colors.white),
                _buildButton('2', Colors.white),
                _buildButton('3', Colors.white),
                _buildButton('+', Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton('√', Colors.orange),
                _buildButton('0', Colors.white),
                _buildButton('^', Colors.orange),
                _buildButton('=', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
