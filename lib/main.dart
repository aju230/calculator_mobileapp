import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalApp());
}

class CalApp extends StatelessWidget {
  const CalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // --- 変数の定義 ---
  // 画面に表示するための変数
  String output = "0";

  // 内部で計算に使ったり、状態を保持したりするための変数
  String _output = "0"; // 現在の入力値
  double _num1 = 0;   // 最初に記憶する数
  double _num2 = 0;   // 次に入力される数
  String _operand = ""; // どの演算子(+, -など)が押されたか記憶する

  // --- ボタンが押されたときに呼ばれる関数 ---
  void buttonPressed(String buttonText) {

    // ACボタンが押された場合
    if (buttonText == "AC") {
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operand = "";
    }
    // 演算子ボタンが押された場合
    else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷" || buttonText == "^" || buttonText == "mod") {
      _num1 = double.parse(output); // 現在表示されている数値を最初の数として記憶
      _operand = buttonText;         // 押された演算子を記憶
      _output = "0";                 // ★修正点1: 次の数値を入力するために表示を "0" にリセット
    }
    // =ボタンが押された場合
    else if (buttonText == "=") {
      _num2 = double.parse(output); // 現在表示されている数値を2番目の数として記憶

      // 記憶していた演算子に応じて計算を実行
      if (_operand == "+") {
        _output = (_num1 + _num2).toString();
      }
      if (_operand == "-") {
        _output = (_num1 - _num2).toString();
      }
      if (_operand == "×") {
        _output = (_num1 * _num2).toString();
      }
      if (_operand == "÷") {
        _output = (_num1 / _num2).toString();
      }
      if (_operand == "^") {
        _output = pow(_num1, _num2).toString();
      }
      if (_operand == "mod") {
        _output = (_num1 % _num2).toString();
      }

      // 計算が終わったので、状態をリセット
      _num1 = 0;
      _num2 = 0;
      _operand = "";
    }
    // 数字ボタンが押された場合
    else {
      // ★修正点2: このブロックのロジックを修正
      if (_output == "0") {
        // 表示が "0" の場合は、押された数字で置き換える
        _output = buttonText;
      } else {
        // 表示が "0" でない場合は、末尾に数字を追加する
        _output = _output + buttonText;
      }
    }

    // `setState` を呼ぶことで、画面の表示が更新される
    setState(() {
      // 計算結果が "12.0" のように小数点以下が0の場合、".0" を取り除いて "12" として表示する
      if (_output.contains('.') && _output.endsWith('0')) {
        output = _output.substring(0, _output.length - 2);
      } else {
        output = _output;
      }
    });
  }


  // --- UI部分 ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            // 結果表示エリア
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                output, // ここで `output` 変数の値を表示
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 電卓ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // 各ボタンの onPressed で buttonPressed 関数を呼び出す
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("AC", buttonColor: Colors.grey),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("×", buttonColor: Colors.blue),
                buildButton("÷", buttonColor: Colors.blue),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("+", buttonColor: Colors.blue),
                buildButton("-", buttonColor: Colors.blue),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildButton("0"),
                buildButton("=", buttonColor: Colors.amber),
                buildButton("^", buttonColor: Colors.blue),
                buildButton("mod", buttonColor: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ボタンを生成するためのヘルパー関数
  Widget buildButton(String buttonText, {Color buttonColor = Colors.lightGreen}) {
    return ElevatedButton(
      onPressed: () => buttonPressed(buttonText), // ボタンが押されたら buttonPressed を呼ぶ
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: (buttonText == "AC" || buttonText == "mod") ? 65 : 70, // 文字サイズを調整
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20), // ボタンのサイズを調整
      ),
    );
  }
}
