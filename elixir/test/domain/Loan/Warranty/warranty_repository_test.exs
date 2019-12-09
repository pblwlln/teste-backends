defmodule BcrediBackend.Domain.Loan.Warranty.WarrantyRepositoryTest do
  use ExUnit.Case
  doctest BcrediBackend.Domain.Loan.Warranty.WarrantyRepository

  test 'Dever haver no mínimo 1 garantia de imóvel por proposta - should return true' do
    warranties = [%BcrediBackend.Domain.Loan.Warranty.WarrantySchema{}]

    assert BcrediBackend.Domain.Loan.Warranty.WarrantyRepository.is_warranty_quantity_sufficient?(
             warranties
           ) == true
  end

  test 'Dever haver no mínimo 1 garantia de imóvel por proposta - should return false' do
    assert BcrediBackend.Domain.Loan.Warranty.WarrantyRepository.is_warranty_quantity_sufficient?(
             []
           ) ==
             false
  end

  test 'A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo - should return true' do
    warranties = [
      %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{
        warranty_value: 80_000
      }
    ]

    proposal = %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{
      proposal_loan_value: 40_000
    }

    assert BcrediBackend.Domain.Loan.Warranty.WarrantyRepository.is_warranty_values_sum_sufficient?(
             warranties,
             proposal
           ) == true
  end

  test 'A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo - should return false' do
    warranties = [
      %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{
        warranty_value: 79_999
      }
    ]

    proposal = %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{
      proposal_loan_value: 40_000
    }

    assert BcrediBackend.Domain.Loan.Warranty.WarrantyRepository.is_warranty_values_sum_sufficient?(
             warranties,
             proposal
           ) ==
             false
  end
end
