var fullLocation = function(address, city, state, zip) {
  return address + '\n' + city + ', ' + state + ' ' + zip;
};

var EventForm = React.createClass ({
  handleSubmit: function(e) {
    e.preventDefault();
    e.stopPropagation();

    /**
     * this.refs.x.getDOMNode().value.trim() extracts the value of x from
     * html tags with a 'value' field. This includes the <input/> tag.
     */

    /* Get the name of the event. */
    var name = this.refs.name.getDOMNode().value.trim();

    /* Concat Start Time fields */
    var startMonth = this.refs.startMonth.getDOMNode().value.trim();
    var startDay = this.refs.startDay.getDOMNode().value.trim();
    var startYear = this.refs.startYear.getDOMNode().value.trim();
    var startHr = this.refs.startHr.getDOMNode().value.trim();
    var startMin = this.refs.startMin.getDOMNode().value.trim();
    var startAMPM = this.refs.startAMPM.getDOMNode().value.trim();
    var startTime = startMonth + ' ' + startDay + ', ' + startYear + ', ' + startHr + ':' + startMin + ' ' + startAMPM;

    /* Concat End Time fields */
    var endMonth = this.refs.startMonth.getDOMNode().value.trim();
    var endDay = this.refs.startDay.getDOMNode().value.trim();
    var endYear = this.refs.startYear.getDOMNode().value.trim();
    var endHr = this.refs.startHr.getDOMNode().value.trim();
    var endMin = this.refs.startMin.getDOMNode().value.trim();
    var endAMPM = this.refs.startAMPM.getDOMNode().value.trim();
    var endTime = endMonth + ' ' + endDay + ', ' + endYear + ', ' + endHr + ':' + endMin + ' ' + endAMPM;

    /* Location fields. */
    var street = this.refs.street.getDOMNode().value.trim();
    var city = this.refs.city.getDOMNode().value.trim();
    var state = this.refs.state.getDOMNode().value.trim();
    var zip = this.refs.zip.getDOMNode().value.trim();

    /* Description and How to Find Us*/
    var description = this.refs.description.getDOMNode().value.trim();

    /* Refer to schema.rb for keys. Values are the variables set above. */
    this.props.onEventSubmit({name: name, start: startTime, end: endTime,
      address_1: street, city: city, state: state, zip: zip,
      description: description});
  },

  render: function() {
    var calEvent = this.props.calEvent;
    var name = calEvent.title;
    var startTime = calEvent.start.format('MMMM DD YYYY, hh:mm a');
    var start_month  = calEvent.start.format('MMMM');
    var start_day    = calEvent.start.format('D');
    var start_year   = calEvent.start.format('YYYY');
    var start_hour   = calEvent.start.format('h');
    var start_minute = calEvent.start.format('mm');
    var start_ampm   = calEvent.start.format('a');
    var endTime;
    var eventEnd = calEvent.end;
    if (eventEnd == null) {
      endTime = null;
    } else {
      var end_month  = calEvent.end.format('MMMM');
      var end_day    = calEvent.end.format('D');
      var end_year   = calEvent.end.format('YYYY');
      var end_hour   = calEvent.end.format('h');
      var end_minute = calEvent.end.format('mm');
      var end_ampm   = calEvent.end.format('a');
    }
    var locationDetails = calEvent.location.split("\n");
    var locationStreet = locationDetails[0];

    var cityStateZip = locationDetails[1].split(", ");
    var locationCity = cityStateZip[0];

    var stateAndZip = cityStateZip[1].split(" ")
    var locationState = stateAndZip[0];
    var locationZip = stateAndZip[1];
    var description = calEvent.description;

    return (
      <div>
        <div id="invalid_form_warnings">
          {/* gotta somehow put flash messages here...? */}
          <p><i>invalid submission errors will appear here</i></p>
        </div>

        <form onSubmit={this.handleSubmit}>

        <div id="e_name">
          <label htmlFor="event_name">Name</label><br/>
          <input type="text" defaultValue={name} placeholder="Name" name="event[name]" id="edit_name" className="edit_text_field" ref='name'/>
        </div>

{/* Note: We can use this commented-out code for dates and time, but it's not compatible with IE or Firefox.

        <div id="e_start_datetime">
          <label htmlFor="event_start">Start Time</label><br/>
          Please follow the following format: mm/dd/yyyy, hh:mm am/pm
          <input type="text" defaultValue={startTime} name="event[start]" id="edit_start_time" className="edit_datetime_field" ref='startTime'/>
        </div>

        <div id="e_end_datetime">
          <label htmlFor="event_end">End Time</label><br/>
          Please follow the following format: mm/dd/yyyy, hh:mm am/pm
          <input type="text" defaultValue={endTime} name="event[end]" id="edit_end_time" className="edit_datetime_field" ref='endTime'/>
        </div>
*/}

        <div id="e_start_date">
          <label htmlFor="event_start_date">Start Date</label><br/>
          <input type="text" defaultValue={start_month} placeholder="Month" name="event[start(month)]" id="edit_start_month" className="edit_text_field" style={{width: '37%'}} ref='startMonth'/>
          {' '}
          <input type="text" defaultValue={start_day} placeholder="Day" name="event[start(day)]" id="edit_start_day" className="edit_text_field" style={{width: '2em'}} ref='startDay'/>
          {', '}
          <input type="text" defaultValue={start_year} placeholder="Year" name="event[start(year)]" id="edit_start_year" className="edit_text_field" style={{width: '3em'}} ref='startYear'/>
{/*       <select id="event_start_month" name="event[start(month)]" defaultValue={this.props.start_month} className="drop_down"/>
          {' '}
          <select id="event_start_day" name="event[start(day)]" defaultValue={this.props.start_day} className="drop_down"/>
          {', '}
          <select id="event_start_year" name="event[start(year)]" defaultValue={this.props.start_year} className="drop_down"/>
*/}
        </div>

        <div id="e_start_time">
          <label htmlFor="event_start_time">Start Time</label><br/>
          <input type="text" defaultValue={start_hour} placeholder="Hr" name="event[start(hour)]" id="edit_start_hour" className="edit_text_field" style={{width: '2em'}} ref='startHr'/>
          {' : '}
          <input type="text" defaultValue={start_minute} placeholder="Min" name="event[start(minute)]" id="edit_start_minute" className="edit_text_field" style={{width: '2em'}} ref='startMin'/>
          {' '}
          <input type="text" defaultValue={start_ampm} placeholder="a/p" name="event[start(ampm)]" id="edit_start_ampm" className="edit_text_field" style={{width: '2em'}} ref='startAMPM'/>
{/*          <select id="event_start_hour" name="event[start(hour)]" defaultValue={this.props.start_hour} className="drop_down"/>
          {' : '}
          <select id="event_start_minute" name="event[start(minute)]" defaultValue={this.props.start_minute} className="drop_down"/>
          {' '}
          <select id="event_start_ampm" name="event[start(ampm)]" defaultValue={this.props.start_ampm} className="drop_down"/>
*/}
        </div>

        <div id="e_end_date">
          <label htmlFor="event_end_date">End Date</label><br/>
          <input type="text" defaultValue={end_month} placeholder="Month" name="event[end(month)]" id="edit_end_month" className="edit_text_field" style={{width: '37%'}} ref='endMonth'/>
          {' '}
          <input type="text" defaultValue={end_day} placeholder="Day" name="event[end(day)]" id="edit_end_day" className="edit_text_field" style={{width: '2em'}} ref='endDay'/>
          {', '}
          <input type="text" defaultValue={end_year} placeholder="Year" name="event[end(year)]" id="edit_end_year" className="edit_text_field" style={{width: '3em'}} ref='endYear'/>
{/*          <select id="event_end_month" name="event[end(month)]" defaultValue={this.props.end_month} className="drop_down"/>
          {' '}
          <select id="event_end_day" name="event[end(day)]" defaultValue={this.props.end_day} className="drop_down"/>
          {', '}
          <select id="event_end_year" name="event[end(year)]" defaultValue={this.props.end_year} className="drop_down"/>
*/}
        </div>

        <div id="e_end_time">
          <label htmlFor="event_end_time">End Time</label><br/>
          <input type="text" defaultValue={end_hour} placeholder="Hr" name="event[end(hour)]" id="edit_end_hour" className="edit_text_field" style={{width: '2em'}} ref='endHr'/>
          {' : '}
          <input type="text" defaultValue={end_minute} placeholder="Min" name="event[end(minute)]" id="edit_end_minute" className="edit_text_field" style={{width: '2em'}} ref='endMin'/>
          {' '}
          <input type="text" defaultValue={end_ampm} placeholder="a/p" name="event[end(ampm)]" id="edit_end_ampm" className="edit_text_field" style={{width: '2em'}} ref='endAMPM'/>
{/*          <select id="event_end_hour" name="event[end(hour)]" defaultValue={this.props.end_hour} className="drop_down"/>
          {' : '}
          <select id="event_end_minute" name="event[end(minute)]" defaultValue={this.props.end_minute} className="drop_down"/>
          {' '}
          <select id="event_end_ampm" name="event[end(ampm)]" defaultValue={this.props.end_ampm} className="drop_down"/>
*/}
        </div>

        <div id="e_location">
          <label htmlFor="event_location">Location</label><br/>
          <input type="text" defaultValue={locationStreet} placeholder="Street" name="event[location(street)]" id="edit_location_street" className="edit_text_field" style={{margin: '0 0 0.3em 0'}} ref='street'/><br/>
          <input type="text" defaultValue={locationCity} placeholder="City" name="event[location(city)]" id="edit_location_city" className="edit_text_field" style={{width: '50%'}} ref='city'/>
          {', '}
          <input type="text" defaultValue={locationState} placeholder="State" name="event[location(state)]" id="edit_location_state" className="edit_text_field" style={{width: '2.5em'}} ref='state'/>
          <input type="zip" defaultValue={locationZip} placeholder="Zip" name="event[location(zip)]" id="edit_location_zip" className="edit_text_field" style={{width: '3em'}} ref='zip'/>
{/*          <select id="event_location_state" name="event[location(state)]" defaultValue={locationState} className="drop_down"/>
*/}
        </div>

        <div id="e_description">
          <label htmlFor="edit_description">Description</label><br/>
          <input type="text" defaultValue={description} placeholder="Description" name="event[description]" id="edit_description" className="edit_text_field" style={{height: '9em'}} ref="description"/>
          {/*<form method="post">
            <textarea defaultValue={description} placeholder="Description" name="event[description]" id="edit_description" className="edit_text_field" style={{height: '9em'}}/>
          </form> */}
          {/* this is a hacky html5 not true rich text editor...needs work, but does support copy/paste from ms word, no idea how to save... */}
          {/*<div id="edit_description" dangerouslySetInnerHTML={{__html: description}} contentEditable="true" className="edit_text_field" ref="description"/>*/}
        </div>

        <div style={{float: 'right'}}>
          <input type="submit" className="button" value="save" />
        </div>
        </form>
      </div>
    )
  }
});

var EditEvent = React.createClass ({
  handleEventSubmit: function(event) {
    $.ajax({
      url: '/events/' + this.props.calEvent.id,
      type: 'PUT',
      data: event,
      success: function(data) {
        var timePeriod = timePeriod(moment(event.start), moment(event.end));
        var loc = fullLocation(event.address_1, event.city, event.state, event.zip);
        React.render(
          <div>
            <Event title={event.name} timePeriod={timePeriod} location={loc} description={event.description}/>
            <AdminButtons calEvent={calEvent}/>
          </div>,
          document.getElementById('panel')
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/events/' + this.props.calEvent.id, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    return (
      <EventForm calEvent={this.props.calEvent} onEventSubmit={this.handleEventSubmit}/>
    );
  }
});

/* Image form code

        <div id="e_image">
          <label htmlFor="edit_image">Image</label><br/>
          <p><i>should display image file name here if one has already been uploaded</i></p><br/>
          <form className="edit_event" id="edit_image" encType="multipart/form-data" acceptCharset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;"/>
            <input type="hidden" name="_method" value="patch"/>
            <input type="hidden" name="authenticity_token" value="TLrlBDUtqMELfBt0N9+mAF29VV5T5RQifcEgHtT76m9TG0B7KSaWV0lajswzrcgZCGsc3a569Oo6vfLx69SKgQ=="/>
            <input id="image" type="file" name="event[image]"/>
            <input type="submit" name="commit" value="Upload"/>
          </form>
        </div>
        <br/><br/>
*/
