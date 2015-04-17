/** @jsx React.DOM */
var Event = React.createClass({
  render: function() {
    return (
      <div>
        <div id="image">
          <i>image resizing has to be done, maybe to resize along with page size?</i>
          {/* image here */}
        </div>
        <br/>

        <div id="name">
          <div className="left">
            <p>What</p>
          </div>
          <div className="right">
            <p>
              {this.props.name}
            </p>
          </div>
          <div style={{clear: 'both'}}></div>
        </div>

        <div id="date_time">
          <div className="left">
            <p>When</p>
          </div>
          <div className="right">
            <p>
              {this.props.timePeriod}
            </p>
          </div>
          <div style={{clear: 'both'}}></div>
        </div>

        <div id="location">
          <div className="left">
            <p>Where</p>
          </div>
          <div id="location">
            <div className="left">
              <p>Where</p>
            </div>
            <div className="right" style={{whiteSpace: 'pre-wrap'}}>
              <p>
                {this.props.location}
              </p>
              <p>
                <i>map may be coming soon!</i>
              </p>
            </div>
            <div style={{clear: 'both'}}></div>
          </div>
          <br/>
          <div id="description" dangerouslySetInnerHTML={{__html: this.props.description}}/>
        </div>
        <br/>

        <div id="description" dangerouslySetInnerHTML={{__html: this.props.description}}/>
        <br/>
        <br/>
        <div id="rsvp">
          <i>rsvp under construction</i>
          {/* maybe we should put a link to an rsvp form page or popup... */}
        </div>
        <br/>
        <br/>

        <i>these buttons will only be visible to admin</i>
        {/* if admin, then show edit and delete button */}
        <div>
          <button type='button' id='editEvent' className='button'>edit</button>
          {' '}
          <button type='button' id='deleteEvent' className='button'>delete</button>
        </div>
      </div>
    );
  }
});

var AdminButtons = React.createClass({
  handleDelete: function() {
    $.ajax({
      url: '/events/' + this.props.eventID,
      type: 'DELETE',
      success: function(data) {
        React.render(
          <p id='deleteMsg'>{this.props.title} was successfully removed.</p>,
          document.getElementById('panel')
        );
        $('#calendar').fullCalendar('removeEvents', this.props.eventID);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/events/' + this.props.eventID, status, err.toString());
      }.bind(this)
    });
    return false;
  },

  handleUpdate: function() {
    React.Render(
      <form eventID={this.props.eventID}/>,
      document.getElementById('panel')
    );
    return false;
  },

  render: function() {
    return (
      <table>
        <tr>
          <td>
            <form id='eventEdit' onSubmit={this.handleUpdate}>
              <input type='submit' value='Edit'/>
            </form>
          </td>
          <td>
            <form id='eventDelete' onSubmit={this.handleDelete}>
              <input type='submit' value='Delete'/>
            </form>
          </td>
        </tr>
      </table>
    );
  }
});
