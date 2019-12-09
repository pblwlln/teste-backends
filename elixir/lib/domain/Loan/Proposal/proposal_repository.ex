defmodule BcrediBackend.Domain.Loan.Proposal.ProposalRepository do
  alias BcrediBackend.Domain.Loan.Proposal.ProposalSchema, as: ProposalSchema

  @spec add_proposal(list, %ProposalSchema{}) :: list
  def add_proposal(proposal_list, proposal) do
    proposal_list ++ [proposal]
  end

  @spec update_proposal(list, %ProposalSchema{}) :: list
  def update_proposal(proposal_list, proposal) do
    delete_proposal(proposal_list, proposal)
    |> add_proposal(proposal)
  end

  @spec delete_proposal(list, %ProposalSchema{}) :: list
  def delete_proposal(proposal_list, proposal) do
    Enum.filter(proposal_list, fn listed_proposal ->
      listed_proposal.proposal_id != proposal.proposal_id
    end)
  end
end
