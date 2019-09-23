module OrganisationsHelper
  ALL_ORGANISATIONS = "all".freeze
  NO_ORGANISATION = "none".freeze

  def organisation_title(organisations, id)
    return "No organisation" if [NO_ORGANISATION, nil].include?(id)
    return "All organisations" if id == ALL_ORGANISATIONS

    organisation = organisations.find { |o| o[:id] == id }

    return "Unknown organisation" if organisation == nil

    organisation[:name]
  end
end
