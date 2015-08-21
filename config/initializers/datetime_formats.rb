Date::DATE_FORMATS.merge!(
  date: ->(d) {
    d.strftime("%m/%d/%Y")
  }
)
