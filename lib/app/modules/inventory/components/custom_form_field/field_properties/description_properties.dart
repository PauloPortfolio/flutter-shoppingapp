import 'package:flutter/material.dart';
import 'package:shopingapp/app/modules/inventory/components/custom_form_field/field_validators/validator_abstraction.dart';
import '../../../../../core/properties/app_form_field_sizes.dart';
import 'properties_abstraction.dart';

class DescripProperties extends PropertiesAbstraction {
  @override
  Map<String, dynamic> properties(
    String fieldName,
    String initialValue,
    ValidatorAbstraction fieldValidator,
  ) {
    return {
      'labelText': fieldName,
      'textInputAction': TextInputAction.next,
      'textInputType': TextInputType.multiline,
      'maxLength': FIELD_DESCRIPT_MAX_SIZE,
      'validatorCriteria': fieldValidator,
      'initialValue': initialValue,
    };
  }
}
