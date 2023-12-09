part of 'widgets.dart';

class cardTest extends StatefulWidget {
  final Costs costs;
  const cardTest(this.costs);

  @override
  State<cardTest> createState() => _cardTestState();
}

class _cardTestState extends State<cardTest> {
  @override
  Widget build(BuildContext context) {
    Costs cost = widget.costs;
    return Card(
      color: Colors.black12,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: const CircleAvatar(backgroundImage: AssetImage('assets/mariotest.png')
        ),
        title: 
          Text("${cost.description} (${cost.service})"
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var a in cost.cost ?? [])
            Text("Biaya: Rp.${a.value}"),
            for (var a in cost.cost ?? [])
            Text("ETD: ${a.etd}"),
          ],
        ),
      )
    );}
  }

