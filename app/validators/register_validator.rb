class RegisterValidator < ActiveModel::Validator
  def validate(record)
    length = options[:length]
    field = options[:field]

    if record.send(field).match(/\A(\d){3}[.](\d){3}[.](\d){3}[-](\d){2}$/)
      digits = record.send(field).gsub(/[.-]/, '')
    elsif record.send(field).match(/\A(\d){2}[.](\d){3}[.](\d){3}[\/](\d){4}[-](\d){2}$/)
      digits = record.send(field).gsub(/[\/.-]/, '')
    else
      digits = record.send(field)
    end
    
    validate_register(record, field, length, digits)
  end

  private

  def validate_register(record, field, expected_length, digits)
    if register_conditions(record, field, expected_length, digits)
      record.errors.add(field, I18n.t('register_validator.invalid_registration'))
      return
    end

    register_without_validation = digits[0..-3]
    first_validation = calculate_validation(register_without_validation)
    second_validation = calculate_validation(register_without_validation + first_validation)
    validated_register = register_without_validation + first_validation + second_validation

    if validated_register != digits
      record.errors.add(field, I18n.t('register_validator.invalid_registration'))
    end
  end

  def register_conditions(record, field, expected_length, value)
    value.present? && (invalid_format?(record, field, expected_length, value) || repeat_number?(value))
  end

  def invalid_format?(record, field, expected_length, value)
    if value.length != expected_length
      record.errors.add(field, I18n.t('register_validator.out_range_length', number: value.length, length: expected_length))
      return true
    elsif value.chars.any? { |char| char.match?(/\D/) }
      record.errors.add(field, I18n.t('register_validator.not_is_a_number'))
      return true
    end
    false
  end

  def calculate_validation(register_without_validation)
    if register_without_validation.length <= 10
      validation_number = validation(sum_range(0, register_without_validation, register_without_validation.length))
    else
      first_part = register_without_validation[0..-9]
      second_part = register_without_validation[-8..-1]

      validation_number = validation(
        sum_range(0, first_part, first_part.length) +
        sum_range(0, second_part, second_part.length)
      )
    end
    validation_number
  end

  def repeat_number?(value)
    value.chars.uniq.length == 1
  end

  def sum_range(validation_number, register, remaining_digits, index = 0)
    validation_number += register[index].to_i * (remaining_digits + 1)
    remaining_digits -= 1
    index += 1

    return sum_range(validation_number, register, remaining_digits, index) if remaining_digits > 0

    validation_number
  end

  def validation(result)
    (result % 11 < 2) ? '0' : (11 - result % 11).to_s
  end
end