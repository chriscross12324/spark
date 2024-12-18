import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/widgets/universal/icon_button_widget.dart';
import 'package:spark/widgets/universal/text_button_widget.dart';

import '../../app_constants.dart';

class FilterNode extends StatefulWidget {
  const FilterNode(
      {super.key, this.depth = 1, this.usedFilterTypes = const []});

  final int depth;
  final List<String> usedFilterTypes;

  @override
  State<FilterNode> createState() => _FilterNodeState();
}

class _FilterNodeState extends State<FilterNode> {
  String? selectedFilterType;
  String? selectedValue;
  List<String> availableFilterTypes = [];
  final List<FilterNode> children = [];

  final List<String> filterTypes = ['Region', 'Type', 'Name'];

  final Map<String, List<String>> filterOptions = {
    'Region': ['North', 'South', 'West', 'East'],
    'Type': ['Swim', 'Walk', 'Run'],
    'Name': ['Dolphins', 'Sharks', 'Whales'],
  };

  @override
  void initState() {
    super.initState();
    availableFilterTypes = filterTypes
        .where((type) => !widget.usedFilterTypes.contains(type))
        .toList();

    if (availableFilterTypes.length == 1 && selectedFilterType == null) {
      selectedFilterType = availableFilterTypes.firstOrNull;
    }
  }

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

  void _selectFilterType(String filterType) {
    setState(() {
      selectedFilterType = filterType;
      selectedValue = null;
    });
  }

  void _removeChild(FilterNode child) {
    setState(() {
      children.remove(child);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            selectedFilterType == null ? null : Colors.white.withOpacity(0.15),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: selectedFilterType == null
            ? Row(
                children: availableFilterTypes.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String type = entry.value;

                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButtonWidget(
                            text: type,
                            buttonFunction: () {
                              _selectFilterType(type);
                            },
                          ),
                        ),
                        if (index != availableFilterTypes.length - 1)
                          const SizedBox(width: 5)
                      ],
                    ),
                  );
                }).toList(),
                /*availableFilterTypes.map(
                  (type) {
                    return ;
                  },
                ).toList(),*/
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "${selectedFilterType!} :",
                                style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w900,
                                  color: themeDarkPrimaryText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
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
                                  isDense: true,
                                  items: filterOptions[selectedFilterType!]!
                                      .map((option) => DropdownMenuItem(
                                          value: option, child: Text(option)))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                        if (widget.depth < 3)
                          IconButtonWidget(
                            icon: HugeIcons.strokeRoundedAdd01,
                            buttonFunction: () {
                              _addChild();
                            },
                            height: 30,
                            width: 30,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: children
                        .map((child) => Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                children: [
                                  Expanded(child: child),
                                  IconButtonWidget(
                                    icon: HugeIcons.strokeRoundedDelete02,
                                    iconSize: 20,
                                    buttonFunction: () {
                                      _removeChild(child);
                                    },
                                    height: 30,
                                    width: 30,
                                    borderRadius: 5,
                                  ),
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

class FilterManager extends StatefulWidget {
  const FilterManager({super.key});

  @override
  State<FilterManager> createState() => _FilterManagerState();
}

class _FilterManagerState extends State<FilterManager> {
  final List<FilterModule> topLevelFilters = [];

  void _addTopLevelFilter() {
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    late FilterModule newFilter;
    newFilter = FilterModule(
      key: Key(uniqueId),
      availableFilterTypes: const ['Region', 'Type', 'Name'],
      onDelete: () => _removeTopLevelFilter(uniqueId),
    );

    setState(
      () {
        topLevelFilters.add(newFilter);
      },
    );
  }

  void _removeTopLevelFilter(String id) {
    setState(() {
      topLevelFilters.removeWhere((filter) => filter.key == Key(id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      surfaceTintColor: Colors.white,
      backgroundColor: themeDarkDeepBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Filter',
              style: GoogleFonts.varelaRound(
                fontWeight: FontWeight.w900,
                color: themeDarkPrimaryText,
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: themeDarkForeground),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: topLevelFilters.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return topLevelFilters[index];
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            height: index == topLevelFilters.length ? 0 : 5);
                      },
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          _addTopLevelFilter();
                        },
                        child: Text(
                          "+ Filter Group",
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0095FF),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButtonWidget(text: 'Cancel', buttonFunction: () {}),
                const SizedBox(
                  width: 10,
                ),
                TextButtonWidget(
                    text: 'Apply', buttonFunction: () {}, isPrimary: true)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FilterModule extends StatefulWidget {
  const FilterModule(
      {super.key, required this.availableFilterTypes, this.onDelete});

  final List<String> availableFilterTypes;
  final VoidCallback? onDelete;

  @override
  State<FilterModule> createState() => _FilterModuleState();
}

class _FilterModuleState extends State<FilterModule> {
  String? selectedFilterType;
  String? selectedFilterValue;
  List<FilterModule> childModules = [];

  final List<String> filterTypes = ['Region', 'Type', 'Name'];

  final Map<String, List<String>> filterValues = {
    'Region': ['North', 'South', 'West', 'East'],
    'Type': ['Swim', 'Walk', 'Run'],
    'Name': ['Dolphins', 'Sharks', 'Whales'],
  };

  void _addChild() {
    if (selectedFilterType != null) {
      setState(() {
        childModules.add(
          FilterModule(
            availableFilterTypes: widget.availableFilterTypes
                .where((type) => type != selectedFilterType)
                .toList(),
            onDelete: () => _deleteChild(childModules.length - 1),
          ),
        );
      });
    }
  }

  void _deleteChild(int index) {
    setState(() {
      debugPrint("Deleting: $index");
      childModules.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    /// Automatically select the only Filter Type available
    if (widget.availableFilterTypes.length == 1 && selectedFilterType == null) {
      selectedFilterType = widget.availableFilterTypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.availableFilterTypes.length < 3 ? 20 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
            .withOpacity(widget.availableFilterTypes.length <= 1 ? 0 : 0.15),
      ),
      child: Padding(
        padding:
            EdgeInsets.all(widget.availableFilterTypes.length <= 1 ? 0 : 5),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: selectedFilterType == null
                  ? Row(
                      children: widget.availableFilterTypes
                          .asMap()
                          .entries
                          .map((entry) {
                        final int index = entry.key;
                        final String type = entry.value;

                        return Expanded(
                            child: Row(
                          children: [
                            Expanded(
                              child: TextButtonWidget(
                                text: type,
                                buttonFunction: () {
                                  setState(() {
                                    selectedFilterType = type;
                                    selectedFilterValue = null;
                                  });
                                },
                              ),
                            ),
                            if (index != widget.availableFilterTypes.length - 1)
                              const SizedBox(width: 5),
                          ],
                        ));
                      }).toList(),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(5),
                              ),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Text(
                                    "${selectedFilterType!}: ",
                                    style: GoogleFonts.varelaRound(
                                      fontWeight: FontWeight.w900,
                                      color: themeDarkPrimaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButtonWidget(text: 'Select', buttonFunction: () {})
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Row(
                              children: [
                                if (widget.availableFilterTypes.length > 1) ...[
                                  IconButtonWidget(
                                    height: 35,
                                    width: 35,
                                    icon: HugeIcons.strokeRoundedAdd01,
                                    iconSize: 18,
                                    isClear: true,
                                    buttonFunction: () {
                                      _addChild();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      height: 20,
                                      width: 2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color:
                                              Colors.white.withOpacity(0.15)),
                                    ),
                                  )
                                ],
                                IconButtonWidget(
                                  height: 35,
                                  width: 35,
                                  icon: HugeIcons.strokeRoundedDelete02,
                                  iconSize: 18,
                                  iconColour: Colors.red,
                                  backgroundTint: Colors.red,
                                  isClear: true,
                                  buttonFunction: () {
                                    debugPrint("Going to delete");
                                    widget.onDelete!();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            if (childModules.isNotEmpty) ...[
              const SizedBox(height: 5),
              ...childModules
                  .expand((child) => [child, const SizedBox(height: 5)])
                  .toList()
                ..removeLast()
            ]
          ],
        ),
      ),
    );
  }
}
