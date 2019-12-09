defmodule BcrediBackend.Domain.Loan.Warranty.WarrantySchema do
  defstruct [
    :proposal_id,
    :warranty_id,
    :warranty_value,
    :warranty_province
  ]

  @doc """
  As garantias de imóvel dos estados PR, SC e RS não são aceitas

  ## Examples

      iex> %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{warranty_province: "PR"}
      ...> |> BcrediBackend.Domain.Loan.Warranty.WarrantySchema.is_valid_province?
      false

      iex> %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{warranty_province: "SC"}
      ...> |> BcrediBackend.Domain.Loan.Warranty.WarrantySchema.is_valid_province?
      false

      iex> %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{warranty_province: "RS"}
      ...> |> BcrediBackend.Domain.Loan.Warranty.WarrantySchema.is_valid_province?
      false

      iex> %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{warranty_province: "SP"}
      ...> |> BcrediBackend.Domain.Loan.Warranty.WarrantySchema.is_valid_province?
      true
  """
  @spec is_valid_province?(%BcrediBackend.Domain.Loan.Warranty.WarrantySchema{}) :: boolean
  def is_valid_province?(warranty) do
    invalidProvinces = ["PR", "SC", "RS"]
    !Enum.member?(invalidProvinces, warranty.warranty_province)
  end
end
