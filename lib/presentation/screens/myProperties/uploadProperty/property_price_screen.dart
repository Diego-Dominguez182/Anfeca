
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyPriceScreen extends StatefulWidget {
  final String? idProperty;

  const PropertyPriceScreen({Key? key, this.idProperty}) : super(key: key);

  @override
  _PropertyPriceScreenState createState() => _PropertyPriceScreenState();
}

class _PropertyPriceScreenState extends State<PropertyPriceScreen> {
  int _currentPrice = 0;
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Precio de la Propiedad'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona el precio:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Slider(
              value: _currentPrice.toDouble(),
              min: 0,
              max: 30000, 
              divisions: 5000,
              label: _currentPrice.toString(),
              onChanged: (double value) {
                if (value > 0 && value < 20000)
                setState(() {
                  _currentPrice = value.toInt();
                  _priceController.text = value.toInt().toString();
                });
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
  int? parsedValue = int.tryParse(value);
  if (parsedValue != null && parsedValue >= 0 && parsedValue <= 30000) {
    setState(() {
      _currentPrice = parsedValue;
    });
  }
},

            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _savePrice();
              },
              child: Text('Guardar Precio'),
            ),
          ],
        ),
      ),
    );
  }

  void _savePrice() {
    int price = int.tryParse(_priceController.text) ?? 0;

    if (price > 0 && price < 30000) {
      FirebaseFirestore.instance.collection('Property').doc(widget.idProperty).update({
        'price': price,
      }).then((value) {
        print('Precio de la propiedad guardado correctamente');
        Navigator.pop(context); 
      }).catchError((error) {
        print('Error al guardar el precio de la propiedad: $error');
      });
    } else if (price > 30000) {
            showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Precio excedido"),
            content: Text("Monto máximo es 30,000 pesos."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
      else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Por favor, ingresa un precio válido."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
    }
  }

