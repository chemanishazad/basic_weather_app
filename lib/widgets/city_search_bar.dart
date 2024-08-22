import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CitySearchBar extends StatelessWidget {
  final TextEditingController citySearchController;
  final Function(String) onSend;

  const CitySearchBar({
    Key? key,
    required this.citySearchController,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 76, 0, 51),
          width: 1.5,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              style: const TextStyle(
                fontSize: 14,
              ),
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              controller: citySearchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter City",
                hintStyle: const TextStyle(fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              onSend(citySearchController.text.trim());
            },
            icon: const Icon(
              Icons.send_sharp,
              size: 20,
              color: Color.fromARGB(255, 76, 0, 51),
            ),
          ),
        ],
      ),
    );
  }
}
