defmodule BcrediBackend.Application.QueueProcessor do
  alias BcrediBackend.Application.LoansEventHandler, as: LoansEventHandler

  def process([head | tail]) do
    process([head | tail], %{proposals: [], warranties: [], proponents: []}, [])
  end

  def process([], loans, _processed_events) do
    loans
  end

  def process([head | tail], loans, processed_events) do
    parsed_event = LoansEventHandler.parse_event(head)
    processed_events = processed_events ++ [parsed_event]

    unless is_event_already_processed?(parsed_event, processed_events) and
             is_event_late?(parsed_event, processed_events) do
      process(
        tail,
        LoansEventHandler.handle_event(loans, parsed_event),
        processed_events
      )
    else
      process(tail, loans, processed_events)
    end
  end

  defp is_event_already_processed?(event, processed_events) do
    unless Enum.empty?(processed_events) do
      Enum.any?(processed_events, fn past_event -> past_event.event_id == event.event_id end)
    else
      false
    end
  end

  defp is_event_late?(event, processed_events) do
    unless Enum.empty?(processed_events) do
      Enum.any?(
        processed_events,
        fn past_event ->
          past_event.event_payload.proposal_id == event.event_payload.proposal_id and
            past_event.event_schema == event.event_schema and
            past_event.event_action == event.event_action and
            past_event.event_timestamp > event.event_timestamp
        end
      )
    else
      false
    end
  end
end
