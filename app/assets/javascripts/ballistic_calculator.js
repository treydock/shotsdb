$(document).on("turbolinks:load", function() {
  var loads = $('#ballistic_calculator_load_id').html();
  var load = $('#ballistic_calculator_load_id :selected').val();
  var guns = $('#ballistic_calculator_gun_id').html();
  var gun = $('#ballistic_calculator_gun_id :selected').val();
  caliber = $('#ballistic_calculator_caliber_id :selected').text();
  if (caliber) {
    set_by_caliber(load, loads, gun, guns);
  }
  $('#ballistic_calculator_caliber_id').change(function() {
    set_by_caliber(load, loads, gun, guns);
  });

  $('#ballistic_calculator_load_id').change(function(e) {
    load_id = $('#ballistic_calculator_load_id :selected').val();
    $.ajax({
      type: 'GET',
      url: '/loads/' + load_id,
      dataType: 'json',
      success: function(result) {
        velocity = result["velocity"];
        bc = result["bullet"]["ballistic_coefficient"];
        if (!$('#ballistic_calculator_ballistic_coefficient').val()) {
          $('#ballistic_calculator_ballistic_coefficient').val(bc);
        }
        if (!$('#ballistic_calculator_velocity').val()) {
          $('#ballistic_calculator_velocity').val(velocity);
        }
      }
    });
  })

  $('#ballistic_calculator_gun_id').change(function(e) {
    gun_id = $('#ballistic_calculator_gun_id :selected').val();
    $.ajax({
      type: 'GET',
      url: '/guns/' + gun_id,
      dataType: 'json',
      success: function(result) {
        console.log(result);
        sight_height = result["sight_height"];
        zero_distance = result["zero_distance"];
        if (!$('#ballistic_calculator_height_of_sight').val()) {
          $('#ballistic_calculator_height_of_sight').val(sight_height);
        }
        if (!$('#ballistic_calculator_zero_range').val()) {
          $('#ballistic_calculator_zero_range').val(zero_distance);
        }
      }
    });
  })

  function set_by_caliber(load, loads, gun, guns) {
      caliber = $('#ballistic_calculator_caliber_id :selected').text();
      if (!caliber) {
        $('#ballistic_calculator_load_id').html(loads);
        $('#ballistic_calculator_gun_id').html(guns);
        return
      }
      load_options = $(loads).filter("optgroup[label=" + caliber + "]").html();
      gun_options = $(guns).filter("optgroup[label=" + caliber + "]").html();
      if (load_options) {
        $('#ballistic_calculator_load_id').html(load_options);
        if (!load) {
          $('#ballistic_calculator_load_id').prepend("<option value='' selected='selected'></option>");
        }
      } else {
        $('#ballistic_calculator_load_id').empty();
      }
      if (gun_options) {
        $('#ballistic_calculator_gun_id').html(gun_options);
        if (!gun) {
          $('#ballistic_calculator_gun_id').prepend("<option value='' selected='selected'></option>");
        }
      } else {
        $('#ballistic_calculator_gun_id').empty();
      }
  }

  function get_load(load_id) {
    $.ajax({
      type: 'GET',
      url: '/loads/' + load_id,
      dataType: 'json',
      async: false,
      success: function(result) {
        console.log(result);
        return result;
      }
    });
  }
});