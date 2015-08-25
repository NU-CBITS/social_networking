Date::DATE_FORMATS.merge!(
  participant_date: ->(d) {
    d.strftime("%b %d %Y")
  }
)
