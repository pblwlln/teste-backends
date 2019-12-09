defmodule BcrediBackend.Domain.Loan.Proponent.ProponentSchema do
  defstruct [
    :proposal_id,
    :proponent_id,
    :proponent_name,
    :proponent_age,
    :proponent_monthly_income,
    :proponent_is_main
  ]

  @doc """
  Todos os proponentes devem ser maiores de 18 anos

  ## Examples

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 0}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_age_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 17}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_age_valid?
      false

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 199}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_age_valid?
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 18}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_age_valid?
      true
  """
  @spec is_age_valid?(%BcrediBackend.Domain.Loan.Proponent.ProponentSchema{}) :: boolean
  def is_age_valid?(proponent) do
    proponent.proponent_age >= 18
  end

  @doc """
  A renda do proponente principal deve ser pelo menos:
    4 vezes o valor da parcela do empréstimo, se a idade dele for entre 18 e 24 anos
    3 vezes o valor da parcela do empréstimo, se a idade dele for entre 24 e 50 anos
    2 vezes o valor da parcela do empréstimo, se a idade dele for acima de 50 anos

  ## Examples
      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 18, proponent_monthly_income: 8}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 24, proponent_monthly_income: 8}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 18, proponent_monthly_income: 7.9}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      false

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 25, proponent_monthly_income: 6}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 50, proponent_monthly_income: 6}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 25, proponent_monthly_income: 5.9}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      false

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 199, proponent_monthly_income: 4}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 50, proponent_monthly_income: 4}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      true

      iex> %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_age: 50, proponent_monthly_income: 3.9}
      ...> |> BcrediBackend.Domain.Loan.Proponent.ProponentSchema.is_monthly_income_sufficient?(2)
      false
  """
  @spec is_monthly_income_sufficient?(
          %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{},
          number
        ) :: boolean
  def is_monthly_income_sufficient?(proponent, monthly_installment_value) do
    cond do
      proponent.proponent_age < 25 ->
        proponent.proponent_monthly_income >= monthly_installment_value * 4

      proponent.proponent_age >= 25 and proponent.proponent_age < 50 ->
        proponent.proponent_monthly_income >= monthly_installment_value * 3

      proponent.proponent_age >= 50 ->
        proponent.proponent_monthly_income >= monthly_installment_value * 2
    end
  end
end
