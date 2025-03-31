import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spark/widgets/common/base_dialog.dart';
import 'package:spark/widgets/common/text_button_widget.dart';

import '../../app_constants.dart';
import 'icon_button_widget.dart';

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
    return BaseDialog(
      dialogTitle: 'Filter',
      dialogHeaderWidget: TextButtonWidget(
        onPressed: () {
          _addTopLevelFilter();
        },
        text: "+ Filter Group",
        containsPadding: false,
      ),
      dialogContent: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: topLevelFilters.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return topLevelFilters[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: index == topLevelFilters.length ? 0 : 5);
            },
          ),
        ],
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
    'Region': [
      'Coastal',
      'Kamloops',
      'South East',
      'Carabao',
      'Prince George',
      'South West',
      'Columbia',
      'Aero',
      'Cranbrook',
      'Flathead'
    ],
    'Type': ['IA', 'UC'],
    'Name': [
      'Alpha',
      'Beta',
      'Charlie',
      'Delta',
      'SE 410',
      'SE 430',
      'SE 450',
      'SE 470',
      'SE 490'
    ],
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
                                onPressed: () {
                                  setState(() {
                                    selectedFilterType = type;
                                    selectedFilterValue = null;
                                  });
                                },
                                containsPadding: false,
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
                                    style: GoogleFonts.asap(
                                      fontWeight: FontWeight.w900,
                                      color: themeDarkPrimaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        customButton: TextButtonWidget(
                                          text: selectedFilterValue ?? 'Select',
                                          onPressed: () {},
                                          ignoreInput: true,
                                        ),
                                        buttonStyleData: ButtonStyleData(
                                            overlayColor:
                                                WidgetStateProperty.all(
                                                    Colors.transparent)),
                                        items:
                                            filterValues[selectedFilterType!]!
                                                .map(
                                                  (option) => DropdownMenuItem(
                                                    value: option,
                                                    child: Text(
                                                      option,
                                                      style: GoogleFonts.asap(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            themeDarkPrimaryText,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                        value: selectedFilterValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedFilterValue = value;
                                          });
                                        },
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 250,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: themeDarkForeground,
                                          ),
                                          offset: const Offset(-20, 0),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 45,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                    isIdleClear: true,
                                    onPressed: () {
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
                                  colour: Colors.red,
                                  isIdleClear: true,
                                  onPressed: () {
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
