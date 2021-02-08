import 'package:flutter/material.dart';

class NumberSelectionField extends FormField<int> {
  NumberSelectionField({
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(
                        flex: 10,
                      ),
                      IconButton(
                        icon: Icon(Icons.remove, size: 30),
                        onPressed: () {
                          if (state.value == 0) return;

                          state.didChange(state.value - 1);
                        },
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Text(
                        state.value.toString(),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30,
                        ),
                        onPressed: () {
                          state.didChange(state.value + 1);
                        },
                      ),
                      Spacer(
                        flex: 10,
                      ),
                    ],
                  ),
                ],
              );
            });
}
