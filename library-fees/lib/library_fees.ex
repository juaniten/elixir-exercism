defmodule LibraryFees do
  def datetime_from_string(string) do
    {_, naive} = NaiveDateTime.from_iso8601(string)
    naive
  end

  def before_noon?(datetime) do
    time = NaiveDateTime.to_time(datetime)
    {_, noon} = Time.new(12,0,0)
    Time.compare(time, noon) == :lt
  end

  def return_date(checkout_datetime) do
    checkout_date = NaiveDateTime.to_date(checkout_datetime)
    days_to_add = if before_noon?(checkout_datetime), do: 28, else: 29
    Date.add(checkout_date, days_to_add)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_date = NaiveDateTime.to_date(actual_return_datetime)
    days_difference = Date.diff(actual_return_date, planned_return_date)
    max(days_difference, 0)
  end

  def monday?(datetime) do
    date = NaiveDateTime.to_date(datetime)
    Date.day_of_week(date) == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    planned_return_date = return_date(checkout_datetime)

    actual_return_datetime = datetime_from_string(return)

    days = days_late(planned_return_date, actual_return_datetime)
    fee = if monday?(actual_return_datetime), do: rate / 2, else: rate

    floor(days * fee)
  end
end
