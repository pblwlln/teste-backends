defmodule BcrediBackend.Domain.Loan.Proponent.ProponentRepository do
  alias BcrediBackend.Domain.Loan.Proponent.ProponentSchema, as: ProponentSchema

  @spec add_proponent(list, %ProponentSchema{}) :: list
  def add_proponent(proponent_list, proponent) do
    proponent_list ++ [proponent]
  end

  @spec update_proponent(list, %ProponentSchema{}) :: list
  def update_proponent(proponent_list, proponent) do
    delete_proponent(proponent_list, proponent)
    |> add_proponent(proponent)
  end

  @spec delete_proponent(list, %ProponentSchema{}) :: list
  def delete_proponent(proponent_list, proponent) do
    Enum.filter(proponent_list, fn listed_proponent ->
      listed_proponent.proponent_id != proponent.proponent_id
    end)
  end

  @doc """
  Deve haver no mínimo 2 proponentes por proposta
  """
  def is_proponents_quantity_sufficient?(proponents) do
    Enum.count(proponents) >= 2
  end

  @doc """
  Deve haver exatamente 1 proponente principal por proposta
  """
  def is_only_one_main_proponent?(proponents) do
    Enum.count(proponents, fn proponent -> proponent.proponent_is_main == true end) == 1
  end

  def is_proposal_proponents_valid?(proponents, proposal) do
    Enum.all?(proponents, fn proponent ->
      validate_proponent(proponent, proposal)
    end)
  end

  defp validate_proponent(proponent, proposal) do
    if proponent.proponent_is_main do
      ProponentSchema.is_age_valid?(proponent) and
        ProponentSchema.is_monthly_income_sufficient?(
          proponent,
          proposal.proposal_loan_value / proposal.proposal_number_of_monthly_installments
        )
    else
      ProponentSchema.is_age_valid?(proponent)
    end
  end
end
