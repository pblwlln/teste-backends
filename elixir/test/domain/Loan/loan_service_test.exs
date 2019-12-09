defmodule BcrediBackend.Domain.Loan.LoanServiceTest do
  use ExUnit.Case
  doctest BcrediBackend.Domain.Loan.LoanService

  test 'Proposal should be valid' do
    warranty = %BcrediBackend.Domain.Loan.Warranty.WarrantySchema{
      proposal_id: "123-abc",
      warranty_id: "warranty_id_1",
      warranty_value: 60_000.0,
      warranty_province: "RJ"
    }

    proponent1 = %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{
      proposal_id: "123-abc",
      proponent_id: "prop_id_1",
      proponent_name: "Proponent 1",
      proponent_age: 18,
      proponent_monthly_income: 5_000.0,
      proponent_is_main: true
    }

    proponent2 = %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{
      proposal_id: "123-abc",
      proponent_id: "prop_id_2",
      proponent_name: "Proponent 2",
      proponent_age: 24,
      proponent_monthly_income: 3_500.0,
      proponent_is_main: false
    }

    proposal = %BcrediBackend.Domain.Loan.Proposal.ProposalSchema{
      proposal_id: "123-abc",
      proposal_loan_value: 30_000.0,
      proposal_number_of_monthly_installments: 24
    }

    loans = %{
      proposals: [proposal],
      warranties: [warranty],
      proponents: [proponent1, proponent2]
    }

    assert BcrediBackend.Domain.Loan.LoanService.is_valid_proposal?(loans, proposal) == true
  end
end
