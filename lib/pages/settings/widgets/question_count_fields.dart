import 'package:flutter/material.dart';

class QuestionCountFields extends FormField<int> {
  QuestionCountFields({
    FormFieldSetter<int> onSaved,
    FormFieldValidator<int> validator,
    int initialValue,
    List<int> options,
    String label,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<int> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: state.hasError ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: options
                        .map(
                          (option) => _QuestionCountField(
                            value: option,
                            isSelected: state.value == option,
                            onPress: () {
                              state.didChange(option);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (state.hasError)
                  Text(
                    state.errorText,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}

class _QuestionCountField extends StatelessWidget {
  _QuestionCountField({
    @required this.value,
    @required this.isSelected,
    @required this.onPress,
  });

  final int value;
  final bool isSelected;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 60,
        width: 50,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          value.toString(),
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey,
            fontSize: 23,
          ),
        ),
      ),
    );
  }
}
