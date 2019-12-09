defmodule BcrediBackend.Domain.Loan.Proponent.ProponentRepositoryTest do
  use ExUnit.Case
  doctest BcrediBackend.Domain.Loan.Proponent.ProponentRepository

  test 'Deve haver no mínimo 2 proponentes por proposta - no proponent - should return false' do
    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_proponents_quantity_sufficient?(
             []
           ) ==
             false
  end

  test 'Deve haver no mínimo 2 proponentes por proposta - 1 proponent - should return false' do
    proponents = [%BcrediBackend.Domain.Loan.Proponent.ProponentSchema{}]

    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_proponents_quantity_sufficient?(
             proponents
           ) ==
             false
  end

  test 'Deve haver no mínimo 2 proponentes por proposta - 2 proponents - should return true' do
    proponents = [
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{},
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{}
    ]

    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_proponents_quantity_sufficient?(
             proponents
           ) == true
  end

  test 'Deve haver exatamente 1 proponente principal por proposta - no main proponent - should return false' do
    proponents = [
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{},
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{}
    ]

    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_only_one_main_proponent?(
             proponents
           ) ==
             false
  end

  test 'Deve haver exatamente 1 proponente principal por proposta - 2 main proponent - should return true' do
    proponents = [
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_is_main: true},
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_is_main: true}
    ]

    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_only_one_main_proponent?(
             proponents
           ) ==
             false
  end

  test 'Deve haver exatamente 1 proponente principal por proposta - no main proponent - should return true' do
    proponents = [
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{proponent_is_main: true},
      %BcrediBackend.Domain.Loan.Proponent.ProponentSchema{}
    ]

    assert BcrediBackend.Domain.Loan.Proponent.ProponentRepository.is_only_one_main_proponent?(
             proponents
           ) ==
             true
  end
end
