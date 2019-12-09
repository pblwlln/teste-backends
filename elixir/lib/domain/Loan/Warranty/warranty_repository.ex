defmodule BcrediBackend.Domain.Loan.Warranty.WarrantyRepository do
  alias BcrediBackend.Domain.Loan.Warranty.WarrantySchema, as: WarrantySchema
  alias BcrediBackend.Domain.Loan.Proposal.ProposalSchema, as: ProposalSchema

  @spec add_warranty(list, %WarrantySchema{}) :: list
  def add_warranty(warranty_list, warranty) do
    warranty_list ++ [warranty]
  end

  @spec update_warranty(list, %WarrantySchema{}) :: list
  def update_warranty(warranty_list, warranty) do
    delete_warranty(warranty_list, warranty)
    |> add_warranty(warranty)
  end

  @spec delete_warranty(list, %WarrantySchema{}) :: list
  def delete_warranty(warranty_list, warranty) do
    Enum.filter(warranty_list, fn listed_warranty ->
      listed_warranty.warranty_id != warranty.warranty_id
    end)
  end

  def is_all_warranties_valid?(warranties) do
    Enum.all?(warranties, fn warranty -> WarrantySchema.is_valid_province?(warranty) end)
  end

  @doc """
  Dever haver no mínimo 1 garantia de imóvel por proposta
  """
  def is_warranty_quantity_sufficient?(warranties) do
    Enum.count(warranties) > 0
  end

  @doc """
  A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo
  """
  @spec is_warranty_values_sum_sufficient?(list, %ProposalSchema{}) :: boolean
  def is_warranty_values_sum_sufficient?(warranties, proposal) do
    warranties_sum =
      Enum.reduce(warranties, 0, fn warranty, acc -> warranty.warranty_value + acc end)

    warranties_sum >= proposal.proposal_loan_value * 2
  end
end
