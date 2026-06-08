<div style="max-width:600px; margin:40px auto; padding:30px;
            background:white; border-radius:12px;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);">
  <h2 style="margin-top:0; color:#833c00;">⏰ Time-Travel (Testadmin)</h2>
 
  <% if @simulated_time %>
    <div style="background:#fce4d6; padding:15px; border-radius:8px;
                margin-bottom:20px;">
      <strong>Aktive Simulation:</strong>
      <%= @simulated_time.strftime('%d.%m.%Y %H:%M') %>
    </div>
    <%= button_to 'Zurück zur Echtzeit', admin_time_travel_path,
        method: :delete,
        style: "background:#e74c3c; color:white; border:none; padding:10px 20px;
               border-radius:6px; cursor:pointer; margin-bottom:20px;" %>
  <% else %>
    <p style="color:#666;">Aktuell läuft die Echtzeit.
      Wähle unten ein Datum zum Simulieren.</p>
  <% end %>
 
  <%= form_with url: admin_time_travel_path, method: :patch, local: true do |f| %>
    <div style="margin-bottom:20px;">
      <%= f.label :target_time, 'Zieldatum & Uhrzeit',
          style: "display:block; margin-bottom:8px; font-weight:bold;" %>
      <%= f.datetime_local_field :target_time,
          value: (@simulated_time || Time.current).strftime('%Y-%m-%dT%H:%M'),
          style: "width:100%; padding:10px; border:1px solid #ddd;
                 border-radius:6px; font-size:16px;" %>
    </div>
    <%= f.submit 'Zeit simulieren',
        style: "width:100%; padding:12px; background:#833c00; color:white;
               border:none; border-radius:6px; font-size:16px; cursor:pointer;" %>
  <% end %>
 
  <p style="margin-top:20px;">
    <%= link_to '← Zum Dashboard', root_path,
        style: "color:#0066cc; text-decoration:none;" %>
  </p>
</div>
