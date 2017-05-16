defmodule Healthlocker.CareTeam.ContactController do
  use Healthlocker.Web, :controller

  def show(conn, _params) do
    service_user = service_user_for(conn.assigns.current_user)

    conn
    |> assign(:service_user, service_user)
    |> assign(:care_team, care_team_for(service_user))
    |> render("show.html")
  end
  defp care_team_for(service_user) do
    query = from e in Healthlocker.EPJSTeamMember,
      where: e."Patient_ID" == ^service_user.slam_id,
      select: e."Staff_ID"

    clinician_ids = Healthlocker.ReadOnlyRepo.all(query)

    query = from c in Healthlocker.EPJSClinician,
      where: c.id in ^clinician_ids

    Healthlocker.ReadOnlyRepo.all(query)
  end
end
