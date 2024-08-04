import 'package:flutter/material.dart';

import 'Button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String number2 = "";
  String operand = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(

        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text("Calculator"),
        // ),
        // backgroundColor: Colors.grey,
        body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          //Widget for handling output of the calculator
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 48),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          //Widget for handling functionality of the calculator
          Wrap(
            children: Button.buttonValues
                .map((value) => SizedBox(
                    width: value == Button.calculate
                        ? screenSize.width / 2
                        : (screenSize.width / 4),
                    height: screenSize.width / 5,
                    child: buildButton(value)))
                .toList(),
          ),
        ],
      ),
    ));
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
            //###############
            onTap: () => onBtnTap(value),
            //############
            child: Center(
                child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
  //########################

  void onBtnTap(String value) {
    if (value == Button.del) {
      delete();
      return;
    }
    if (value == Button.clr) {
      clearAll();
      return;
    }
    if (value == Button.per) {
      percentage();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  //#########################
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Button.add:
        result = num1 + num2;
        break;
      case Button.subtract:
        result = num1 - num2;
        break;

      case Button.multiply:
        result = num1 * num2;
        break;

      case Button.divide:
        result = num1 + num2;
        break;

      default:
    }
    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }
  //#########################

  void percentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  //#########################
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //#########################
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  //########################
  void appendValue(String value) {
    if (value != Button.dot && int.tryParse(value) == null) {
      if (operand.isEmpty && number2.isEmpty) {
        //todo calculator function will be called here
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Button.dot && number1.contains(Button.dot)) return;
      if (value == Button.dot && (number1.isEmpty || number1 == Button.dot)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Button.dot && number2.contains(Button.dot)) return;
      if (value == Button.dot && (number2.isEmpty || number2 == Button.dot)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
  //########################

  Color getBtnColor(value) {
    return [Button.del, Button.clr].contains(value)
        ? Colors.blueGrey
        : [
            Button.per,
            Button.add,
            Button.subtract,
            Button.multiply,
            Button.divide,
            Button.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
