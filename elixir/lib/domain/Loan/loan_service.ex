defmodule BcrediBackend.Domain.Loan.LoanService do
  alias BcrediBackend.Domain.Loan.Proponent.ProponentRepository, as: ProponentRepository
  alias BcrediBackend.Domain.Loan.Warranty.WarrantyRepository, as: WarrantyRepository
  alias BcrediBackend.Domain.Loan.Proposal.ProposalSchema, as: ProposalSchema

  @spec is_valid_proposal?(
          atom | %{proponents: any, warranties: any},
          BcrediBackend.Domain.Loan.Proposal.ProposalSchema.t()
        ) :: boolean
  def is_valid_proposal?(loans, proposal) do
    proposal_proponents =
      Enum.filter(loans.proponents, fn proponent ->
        proponent.proposal_id == proposal.proposal_id
      end)

    proposal_warranties =
      Enum.filter(loans.warranties, fn warranty ->
        warranty.proposal_id == proposal.proposal_id
      end)

    validations = [
      ProposalSchema.is_proposal_loan_value_valid?(proposal),

      # Warranty validations
      WarrantyRepository.is_all_warranties_valid?(proposal_warranties),
      WarrantyRepository.is_warranty_quantity_sufficient?(proposal_warranties),
      WarrantyRepository.is_warranty_values_sum_sufficient?(proposal_warranties, proposal),

      # Proponent Validations
      ProposalSchema.is_proposal_number_of_monthly_installments_valid?(proposal),
      ProponentRepository.is_proposal_proponents_valid?(proposal_proponents, proposal),
      ProponentRepository.is_proponents_quantity_sufficient?(proposal_proponents),
      ProponentRepository.is_only_one_main_proponent?(proposal_proponents)
    ]

    Enum.all?(validations, fn validation_return -> validation_return == true end)
  end
end
