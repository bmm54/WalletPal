import 'package:bstable/models/accounts_model.dart';
import 'package:bstable/screens/Home/add/account.dart';
import 'package:bstable/screens/Home/add/exp_category.dart';
import 'package:bstable/screens/Home/add/inc_category.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../sql/sql_helper.dart';

// ignore: must_be_immutable
class CalculatorScreen extends StatefulWidget {
  final String type;
  late String category;
  CalculatorScreen({super.key, required this.type}) {
    type == 'expense' ? category = "Grocery" : category = "Salary";
  }
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  List accounts = Accounts.getAccounts;
  String accountName = '';
  int accountId = 0;
  @override
  void initState() {
    super.initState();
    if (accounts.isNotEmpty)
    {accountName = accounts[accounts.length-1]['name'];
    accountId = accounts[accounts.length-1]['id'];}
  }

  String _output = '';
  String _input = '';

  String getOutput() {
    return _output;
  }

  void _handleButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        _output = _calculateResult();
        _output == "Error" ? _input = _input : _input = _output;
      } else if (buttonText == 'C') {
        _output = '';
        _input = '';
      } else if (buttonText == 'Confirm') {
        SQLHelper.insertActivity(
            widget.category, widget.type, double.parse(getOutput()));
        SQLHelper.updateBalance(
            double.parse(getOutput()), widget.type, accountId);
        final ready = true;
        Navigator.of(context).pop(ready);
      } else {
        _input += buttonText;
      }
    });
  }

  String _calculateResult() {
    try {
      final result = eval(_input);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberBgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.displaySmall!.color ?? Colors.black;
    final buttonBgColor = Theme.of(context).primaryColor;
    final double buttonWidth = MediaQuery.of(context).size.height * 0.07 + 6;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Account()));
                        setState(
                          () {
                            accountName = result[0];
                            accountId = result[1];
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(buttonBgColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Account",
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            Text(
                              accountName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => widget.type == "expense"
                                    ? ExpenseCategory()
                                    : const IncomeCategory()));
                        setState(() {
                          widget.category = result;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MyColors.purpule),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Category",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _input,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                        color: Theme.of(context).textTheme.displayMedium!.color,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.type == "expense" ? "–" : "+",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: MyColors.purpule,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _output,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildButton('C',
                            color: buttonBgColor, textColor: textColor),
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: _buildButton('/',
                            color: MyColors.purpule, textColor: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildButton('7',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('8',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('9',
                              color: numberBgColor, textColor: textColor)),
                      SizedBox(
                        width: buttonWidth,
                        child: _buildButton('*',
                            color: MyColors.purpule, textColor: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildButton('4',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('5',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('6',
                              color: numberBgColor, textColor: textColor)),
                      SizedBox(
                        width: buttonWidth,
                        child: _buildButton('+',
                            color: MyColors.purpule, textColor: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildButton('1',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('2',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                          child: _buildButton('3',
                              color: numberBgColor, textColor: textColor)),
                      SizedBox(
                        width: buttonWidth,
                        child: _buildButton('-',
                            color: MyColors.purpule, textColor: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildButton('.',
                              color: numberBgColor, textColor: textColor)),
                      Expanded(
                        child: _buildButton('0',
                            color: numberBgColor, textColor: textColor),
                        flex: 2,
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: _buildButton('=',
                            color: MyColors.purpule, textColor: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildButton('Confirm',
                              color: buttonBgColor, textColor: textColor)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText,
      {Color color = Colors.white, Color textColor = Colors.black}) {
    final double buttonSize = MediaQuery.of(context).size.height * 0.07;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        height: buttonSize,
        child: ElevatedButton(
          onPressed: () => _handleButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 30.0, color: textColor, fontWeight: FontWeight.bold),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
    );
  }
}

double eval(String expression) {
  // Remove all whitespace from the expression
  expression = expression.replaceAll(RegExp(r'\s+'), '');

  // Get all the numbers from the expression
  final numbers = RegExp(r'(\d+\.?\d*)').allMatches(expression).map((e) {
    final number = e.group(0);
    return double.parse(number!);
  }).toList();

  // Get all the operators from the expression
  final operators = RegExp(r'(\+|-|\*|/)').allMatches(expression).map((e) {
    final operator = e.group(0);
    return operator;
  }).toList();

  // Perform multiplication and division
  for (var i = 0; i < operators.length; i++) {
    final operator = operators[i];
    final num1 = numbers[i];
    final num2 = numbers[i + 1];

    double result;
    if (operator == '*') {
      result = num1 * num2;
    } else if (operator == '/') {
      result = num1 / num2;
    } else {
      // If the operator is not multiplication or division,
      // no computation is needed at this point
      continue;
    }

    // Remove num1 and num2 from the numbers list
    numbers.removeAt(i);
    numbers.removeAt(i);

    // Insert the result to the numbers list at the same position
    numbers.insert(i, result);

    // Remove the used operator
    operators.removeAt(i);

    // Since we removed one item from the numbers list,
    // we need to decrease i by 1 to compensate
    i--;
  }

  // Perform addition and subtraction
  var result = numbers[0];
  for (var i = 0; i < operators.length; i++) {
    final operator = operators[i];
    final num = numbers[i + 1];

    if (operator == '+') {
      result += num;
    } else if (operator == '-') {
      result -= num;
    }
  }

  return result;
}
