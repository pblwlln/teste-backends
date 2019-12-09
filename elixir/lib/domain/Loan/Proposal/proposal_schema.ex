defmodule BcrediBackend.Domain.Loan.Proposal.ProposalSchema do
  defstruct [
    :proposal_id,
    :proposal_loan_value,
    :proposal_number_of_monthly_installments
  ]

  @doc """
  O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00

  ## Examples

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 29_999.99}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 3_000_000.01}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 2_999_999.99}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 30_000.01}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 30_000.00}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_loan_value: 3_000_000.00}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_loan_value_valid?
      true
  """
  @spec is_proposal_loan_value_valid?(%BcrediBackend.Domain.Loan.Proposal.ProposalSchema{}) ::
          boolean
  def is_proposal_loan_value_valid?(proposal) do
    proposal.proposal_loan_value >= 30_000 and proposal.proposal_loan_value <= 3_000_000
  end

  @doc """
  O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos

  ## Examples

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_number_of_monthly_installments: 181}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_number_of_monthly_installments_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_number_of_monthly_installments: 23}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_number_of_monthly_installments_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_number_of_monthly_installments: 180}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_number_of_monthly_installments_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_number_of_monthly_installments: 24}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_number_of_monthly_installments_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{proposal_number_of_monthly_installments: 90}
      ...> |> BcrediBackend.Domain.Loan.Proposal.ProposalSchema.is_proposal_number_of_monthly_installments_valid?
      true
  """
  @spec is_proposal_number_of_monthly_installments_valid?(
          %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{}
        ) ::
          boolean
  def is_proposal_number_of_monthly_installments_valid?(proposal) do
    proposal.proposal_number_of_monthly_installments <= 180 and
      proposal.proposal_number_of_monthly_installments >= 24
  end
end
