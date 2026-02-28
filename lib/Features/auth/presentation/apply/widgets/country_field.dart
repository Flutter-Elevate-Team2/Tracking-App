import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_app/Features/auth/data/mappers/apply_mapper/country_mapper.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/country_model.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/country_entities.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class CountryField extends StatefulWidget {
  final CountryEntity? initialCountry;
  final ValueChanged<CountryEntity?> onChanged;

  const CountryField({super.key, this.initialCountry, required this.onChanged});

  @override
  State<CountryField> createState() => _CountryDropdownLoaderState();
}

class _CountryDropdownLoaderState extends State<CountryField> {
  List<CountryEntity> _countries = [];
  CountryEntity? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final String response = await rootBundle.loadString(Assets.json.country);

    final List<dynamic> data = json.decode(response);

    final List<CountryModel> countryModels = data
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final List<CountryEntity> countryEntities = countryModels.toEntityList();

    final CountryEntity? egypt = countryEntities.firstWhere(
          (c) => c.name?.toLowerCase() == 'egypt',
      orElse: () => countryEntities.first,
    );

    setState(() {
      _countries = countryEntities;
      _selectedCountry = widget.initialCountry ?? egypt;
      widget.onChanged(_selectedCountry);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_countries.isEmpty) {
      return const CircularProgressIndicator();
    }

    return DropdownButtonFormField<CountryEntity>(
      initialValue: _selectedCountry,
      validator: (value) => value == null ? context.l10n.required : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.country,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: _countries.map((country) {
        return DropdownMenuItem<CountryEntity>(
          value: country,
          child: Text("${country.flag ?? ''} ${country.name ?? ''}"),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
