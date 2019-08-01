module EventsHelper

  # to display event date in human readable format
  def display_date(event)
    event.date.strftime("%B %-d, %Y")
  end
end
