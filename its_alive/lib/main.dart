import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:its_alive/button_values.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String calc = "";
  String currentResult = "";

  String getDisplayValue(String value) {
    if (value == Btn.multiply) {
      return "x";
    }
    return value;
  }

  String convertForParsing(String input) {
    return input.replaceAll("x", "*");
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calculator",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 57, 51, 77),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SingleChildScrollView(
              child:
                Container(
                  alignment: Alignment.topRight,
                  padding:const EdgeInsets.all(4),
                  child: Text(
                    calc.isEmpty
                        ? "0" 
                        : calc,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
            ),
            Expanded(
              child:
                Container(
                  alignment: Alignment.topRight,
                  padding:const EdgeInsets.all(4),
                  child: Text(
                    currentResult.isNotEmpty 
                        ? currentResult 
                        : "0",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0 || value == Btn.calculate
                          ? screenSize.width / 2.75 
                          : (screenSize.width / 5.5),
                      height: screenSize.height / 8,
                      child: buildButton(value),
                    )
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,  //forme du clic de bouton
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white38
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              getDisplayValue(value),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    } 

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.calculate) {
      try {
        final expression = Expression.parse(convertForParsing(calc));
        final evaluator = const ExpressionEvaluator();
        final result = evaluator.eval(expression, {});
        setState(() {
          currentResult = result.toString();
        });
        calc = "";
        return;
      } catch(e) {
        setState(() {
          currentResult = "Malformed Expression";
        });
        clearAll();
        return;
      }
    }
    appendValue(value);
  }

  //clears all output
  void clearAll() {
    setState(() {
      calc = "";
      currentResult = "";
    });
  }

  //delete one from the end
  void delete() {
    if (calc.isNotEmpty) {
      calc = calc.substring(0, calc.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {

    calc += getDisplayValue(value);
    setState(() {}); 
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
            ? Colors.grey
            : [
                Btn.add,
                Btn.multiply,
                Btn.divide,
                Btn.subtract,
                Btn.calculate
              ].contains(value)
                ? const Color.fromARGB(255, 223, 159, 61) 
                : const Color.fromARGB(255, 60, 60, 60);
  }
}