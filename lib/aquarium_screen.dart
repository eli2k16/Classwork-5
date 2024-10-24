import 'package:flutter/material.dart';
import 'fish.dart';
import 'database_helper.dart';  // Updated import

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();  // Load settings when app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/aquarium_background1.jpg'),
            fit: BoxFit.cover, // Make the image cover the entire container
          ),
        ),
        child: Column(
          children: [
            // AppBar as a transparent container
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0), // Add some padding for the title
              color: Colors.transparent, // Make it transparent
              child: Center(
                child: Text(
                  "Virtual Aquarium",
                  style: TextStyle(
                    color: Colors.white, // Change the text color to white for contrast
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Aquarium container (300x300)
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/aquabox.jpg'), // Set your aquarium image as the background
                  fit: BoxFit.cover, // Ensure the image covers the entire container
                ),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: Stack(
                children: fishList.map((fish) => fish.build(context)).toList(),
              ),
            ),
            // Fish settings (Color and Speed)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Color:', style: TextStyle(color: Colors.white)), // Change text color
                DropdownButton<Color>(
                  value: selectedColor,
                  dropdownColor: Colors.blue[200], // Change dropdown background color for better visibility
                  items: [
                    DropdownMenuItem(child: Text("Blue"), value: Colors.blue),
                    DropdownMenuItem(child: Text("Green"), value: Colors.green),
                    DropdownMenuItem(child: Text("Red"), value: Colors.red),
                    // Add more color options if needed
                  ],
                  onChanged: (newColor) {
                    setState(() {
                      selectedColor = newColor!;
                    });
                  },
                ),
                Text('Speed:', style: TextStyle(color: Colors.white)), // Change text color
                Slider(
                  value: selectedSpeed,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  onChanged: (newSpeed) {
                    setState(() {
                      selectedSpeed = newSpeed;
                    });
                  },
                ),
              ],
            ),
            // Buttons to add fish and save settings
            ElevatedButton(
              onPressed: _addFish,
              child: Text("Add Fish"),
            ),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text("Save Settings"),
            ),
          ],
        ),
      ),
    );
  }

  void _addFish() {
    if (fishList.length < 10) { // Limit to 10 fish
      setState(() {
        fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  void _saveSettings() async {
    await saveSettings(fishList.length, selectedColor, selectedSpeed);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Settings saved!'),
    ));
  }

  void _loadSettings() async {
    var settings = await loadSettings();
    if (settings != null) {
      Color loadedColor = Color(settings['color']);
      
      // Check if the loaded color is one of the dropdown options
      if (loadedColor != Colors.blue && loadedColor != Colors.green && loadedColor != Colors.red) {
        loadedColor = Colors.blue;  // Default to Blue if the color is not in the list
      }

      setState(() {
        selectedColor = loadedColor;
        selectedSpeed = settings['speed'];
        for (int i = 0; i < settings['fish_count']; i++) {
          fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
        }
      });
    }
  }
}
