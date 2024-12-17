import 'package:flutter/material.dart';

class FilterNode extends StatefulWidget {
  const FilterNode({super.key, this.depth = 1, this.usedFilterTypes = const []});

  final int depth;
  final List<String> usedFilterTypes;

  @override
  State<FilterNode> createState() => _FilterNodeState();
}

class _FilterNodeState extends State<FilterNode> {
  String? selectedFilterType;
  String? selectedValue;
  final List<FilterNode> children = [];

  final List<String> filterTypes = ['Region', 'Type', 'Name'];

  final Map<String, List<String>> filterOptions = {
    'Region': ['North', 'South', 'West', 'East'],
    'Type': ['Swim', 'Walk', 'Run'],
    'Name': ['Dolphins', 'Sharks', 'Whales'],
  };

  void _addChild() {
    if (widget.depth < 3 && selectedFilterType != null) {
      setState(() {
        children.add(FilterNode(
          depth: widget.depth + 1,
          usedFilterTypes: [...widget.usedFilterTypes, selectedFilterType!],
        ));
      });
    }
  }

  void _removeChild(FilterNode child) {
    setState(() {
      children.remove(child);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> availableFilterTypes = filterTypes.where((type) => !widget.usedFilterTypes.contains(type)).toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  hint: const Text('Select Filter Type'),
                  value: selectedFilterType,
                  items: availableFilterTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilterType = value;
                      selectedValue = null;
                    });
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                if (selectedFilterType != null)
                  DropdownButton<String>(
                    hint: const Text('Select Value'),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    items: filterOptions[selectedFilterType!]!
                        .map((option) => DropdownMenuItem(
                            value: option, child: Text(option)))
                        .toList(),
                  ),
              ],
            ),
            if (widget.depth < 3)
              TextButton.icon(
                onPressed: _addChild,
                icon: const Icon(Icons.add),
                label: const Text('Add Child Filter'),
              ),
            Column(
              children: children
                  .map((child) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Expanded(child: child),
                            IconButton(
                              onPressed: () => _removeChild(child),
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            )
                          ],
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
