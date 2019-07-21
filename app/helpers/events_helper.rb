module EventsHelper
  def date_human(event)
    event.date.strftime("%B %-d, %Y")
  end
end
