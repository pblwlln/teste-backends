defmodule BcrediBackend.Application.LoansEventHandler do
  alias BcrediBackend.Domain.Loan.Proposal.ProposalRepository, as: ProposalRepository
  alias BcrediBackend.Domain.Loan.Proponent.ProponentRepository, as: ProponentRepository
  alias BcrediBackend.Domain.Loan.Warranty.WarrantyRepository, as: WarrantyRepository

  def handle_event(loans, event) do
    case event.event_action do
      "added" -> add_action(loans, event)
      "created" -> add_action(loans, event)
      "updated" -> update_action(loans, event)
      "deleted" -> delete_action(loans, event)
      "removed" -> delete_action(loans, event)
    end
  end

  def parse_event(event) do
    event_as_list = String.split(event, ",")

    event = %{
      event_id: Enum.at(event_as_list, 0),
      event_schema: Enum.at(event_as_list, 1),
      event_action: Enum.at(event_as_list, 2),
      event_timestamp: Enum.at(event_as_list, 3),
      event_payload: nil
    }

    payload_list = Enum.drop(event_as_list, 4)

    case event.event_schema do
      "proposal" -> %{event | event_payload: parse_proposal(payload_list)}
      "proponent" -> %{event | event_payload: parse_proponent(payload_list)}
      "warranty" -> %{event | event_payload: parse_warranty(payload_list)}
    end
  end

  @spec add_action(any, atom | %{event_payload: any, event_schema: <<_::64, _::_*8>>}) :: any
  defp add_action(loans, event) do
    case event.event_schema do
      "proposal" ->
        %{
          loans
          | proposals: ProposalRepository.add_proposal(loans.proposals, event.event_payload)
        }

      "warranty" ->
        %{
          loans
          | warranties: WarrantyRepository.add_warranty(loans.warranties, event.event_payload)
        }

      "proponent" ->
        %{
          loans
          | proponents: ProponentRepository.add_proponent(loans.proponents, event.event_payload)
        }
    end
  end

  defp update_action(loans, event) do
    case event.event_schema do
      "proposal" ->
        %{
          loans
          | proposals: ProposalRepository.update_proposal(loans.proposals, event.event_payload)
        }

      "warranty" ->
        %{
          loans
          | warranties: WarrantyRepository.update_warranty(loans.warranties, event.event_payload)
        }

      "proponent" ->
        %{
          loans
          | proponents:
              ProponentRepository.update_proponent(loans.proponents, event.event_payload)
        }
    end
  end

  defp delete_action(loans, event) do
    case event.event_schema do
      "proposal" ->
        %{
          loans
          | proposals: ProposalRepository.delete_proposal(loans.proposals, event.event_payload)
        }

      "warranty" ->
        %{
          loans
          | warranties: WarrantyRepository.delete_warranty(loans.warranties, event.event_payload)
        }

      "proponent" ->
        %{
          loans
          | proponents:
              ProponentRepository.delete_proponent(loans.proponents, event.event_payload)
        }
    end
  end

  defp parse_proposal(payload) do
    %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{
      proposal_id: Enum.at(payload, 0),
      proposal_loan_value: String.to_float(Enum.at(payload, 1, "0")),
      proposal_number_of_monthly_installments: String.to_integer(Enum.at(payload, 2, "0"))
    }
  end

  defp parse_proponent(payload) do
    %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{
      proposal_id: Enum.at(payload, 0),
      proponent_id: Enum.at(payload, 1),
      proponent_name: Enum.at(payload, 2, ""),
      proponent_age: String.to_integer(Enum.at(payload, 3, "0")),
      proponent_monthly_income: String.to_float(Enum.at(payload, 4, "0.0")),
      proponent_is_main: Enum.at(payload, 5, "false") == "true"
    }
  end

  defp parse_warranty(payload) do
    %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{
      proposal_id: Enum.at(payload, 0),
      warranty_id: Enum.at(payload, 1),
      warranty_value: String.to_float(Enum.at(payload, 2, "0.0")),
      warranty_province: Enum.at(payload, 3, "")
    }
  end
end
