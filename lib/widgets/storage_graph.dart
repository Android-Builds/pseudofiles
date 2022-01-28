import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class StorageGraph extends StatelessWidget {
  const StorageGraph({
    Key? key,
    required this.available,
    required this.total,
    required this.storage,
  }) : super(key: key);
  final String available;
  final String total;
  final String storage;

  @override
  Widget build(BuildContext context) {
    final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    double availableStorage = double.parse(available.toString().split(' ')[0]);
    double totalStorage = double.parse(total.toString().split(' ')[0]);
    double usedStorage = totalStorage - availableStorage;
    final percentage = usedStorage / totalStorage;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.05,
                ),
              ),
              const SizedBox(height: 40.0),
              Text(
                'Free: $availableStorage GB'.replaceAll(regex, ''),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text(
                'Total: $total',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              indicator(accentColor.withAlpha(150), 'Used Space'),
              const SizedBox(height: 5.0),
              indicator(accentColor.withOpacity(0.25), 'Free Space'),
            ],
          ),
          CircularPercentIndicator(
            radius: 150.0,
            animation: true,
            animationDuration: 1200,
            //arcBackgroundColor: Colors.grey,
            lineWidth: 10.0,
            percent: percentage,
            center: Text(
                ((availableStorage / totalStorage) * 100).toStringAsFixed(2) +
                    '% free'),
            //arcType: ArcType.HALF,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: accentColor.withAlpha(150),
            backgroundColor: accentColor.withOpacity(0.25),
            footer: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 20.0,
              ),
              child: Text(
                '${usedStorage.toString().replaceAll(regex, '')} GB used of $total',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget indicator(Color color, String label) => Row(
        children: [
          Container(
            width: size.width * 0.04,
            height: size.width * 0.04,
            color: color,
          ),
          const SizedBox(width: 10.0),
          Text(label)
        ],
      );
}
