Date::DATE_FORMATS.merge!(
  participant_date: ->(d) {
    d.strftime("%m/%d/%Y")
  }
)
