import 'package:flutter/material.dart';
import 'package:sqlite/Doggydatabase/dog.dart';
import 'package:sqlite/Doggydatabase/dogdatabase.dart';
import 'package:animated_background/animated_background.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Doggypage(),
    );
  }
}

class Doggypage extends StatefulWidget {
  @override
  _DoggypageState createState() => _DoggypageState();
}

class _DoggypageState extends State<Doggypage> with TickerProviderStateMixin {
  DogDatabase dogDatabase = DogDatabase();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController idToDeleteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 10.00,
            particleCount: 68,
            spawnMaxSpeed: 50,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            baseColor: Colors.blue,
          ),
        ),
        vsync: this,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: "Age"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Dog newDog = Dog(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: nameController.text,
                        age: int.tryParse(ageController.text) ?? 0,
                      );

                      await dogDatabase.insertDog(newDog);

                      nameController.clear();
                      ageController.clear();
                    },
                    child: const Text("Neuen Hund hinzufügen"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      List<Dog> dogList = await dogDatabase.dogs();
                      for (var dog in dogList) {
                        debugPrint("$dog");
                      }
                      setState(() {});
                    },
                    child: const Text("Datenbank auslesen"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await dogDatabase.deleteDog();
                      debugPrint("Datenbank wurde gelöscht.");
                    },
                    child: const Text("Datenbank löschen"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: idToDeleteController,
                          decoration: const InputDecoration(
                              labelText: "ID zu löschender Hund"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          int idToDelete =
                              int.tryParse(idToDeleteController.text) ?? 0;
                          await dogDatabase.deleteDogById(idToDelete);
                          debugPrint("Hund mit ID $idToDelete wurde gelöscht.");
                          idToDeleteController.clear();
                        },
                        child: const Text("Hund löschen nach ID"),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Dog>>(
                future: dogDatabase.dogs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            snapshot.data![index].name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Age: ${snapshot.data?[index].age}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
