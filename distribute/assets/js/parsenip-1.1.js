var parsenip = {
  instances: [],
  has_running_instances: function() {
    var running = false;
    $.each(this.instances, function(i, instance) {
      if(! instance.complete()){
        running = true;
      }
    });
    return running;
  },
  get_all_parsenip_instances: function() {
    return $('[data-parsenip]');
  },
  reset: function() {
    var _this = this;
    this.get_all_parsenip_instances().each(function(i, parsenip_element){
      var $parsenip = $(parsenip_element);
      var $children = $parsenip.find('*');
      // Delete the guid
      $parsenip
        .removeAttr('id')
        .removeAttr('data-parsenip-initialized');

      // Unbind all of the child elements
      $children.off();
      // Delete all of the child elements
      $parsenip.empty();
      // Clear all instances
      _this.instances = [];
      // Re-initialize all
      _this.initialize_all();
      parsenip.callbacks.reset();
    });
  },
  setup: function() { },
  initialize_all: function() {
    var _this = this;
    this.setup();
    this.get_all_parsenip_instances().filter(':not([data-parsenip-initialized])').each(function(){
      $(this).attr('id', _this.helper.string.generate_uuid());
      $(this).addClass('parsenip');
      _this.initialize_form($(this));
      _this.initialize_confirmation_results($(this));
      _this.initialize_thank_you($(this));

      $(this).attr('data-parsenip-initialized', '1');
      parsenip.callbacks.form_construction_complete($(this));
    });
  },
  initialize_confirmation_results: function($container) {
    var $results = $('<div>').addClass('confirmation-results');
    $container.append($results);
  },
  initialize_thank_you: function($parsenip){
    var $thankyou = $('<div>').addClass('thankyou').addClass('hidden');
    $thankyou.append($('<p>').text(parsenip.text.import_thankyou));
    $parsenip.append($thankyou);
  },
  initialize_form: function($container) {
    var _this = this;
    var $form = $('<form>');
    $form.attr('enctype', 'multipart/form-data');
    $form.addClass('parsenip-upload');

    var $input_container = $('<span>').addClass('input-container');
    var $input_button = $('<span>')
      .text('Upload File')
      .addClass('btn btn-primary btn-file');
    var $input = $('<input>')
      .attr('type', 'file')
      .attr('name', 'file')
      .addClass('parsenip-file-upload')
      .attr('data-url', this.url.upload(parsenip.config))
      .attr('id', 'parsenip-uploader-'+parsenip.helper.string.generate_uuid());

    $form.append(parsenip.helper.spinner.setup());

    $input_button.append($input);
    $input_container.append($input_button);
    $form.append($input_container);

    // Append the form and then initialize the uploader on the input.
    // Even though it's in an "each" loop, it should only run once - for the created input.
    // The "each" ensures that the object is appended prior to initializing.
    $container.append( $form).each(function(i, form){
      var instance = $.extend({}, parsenip.uploader);
      instance.init($container);
      _this.instances.push(instance);
    });
  }
};

/*
 * Helper object for retrieving parsenip urls.
 */
parsenip.url = {
  upload: function(config) {
    return config.url + '/uploads/upload.json?js_api_key=' + config.js_api_key;
  },
  matches: function(config, upload) {
    return config.url + '/uploads/matches.json?js_api_key=' + config.js_api_key + '&upload_token=' + upload.token;
  },
  confirm: function(config, upload) {
    return config.url + '/uploads/confirm.json?js_api_key=' + config.js_api_key + '&upload_token=' + upload.token;
  }
};


/*
 * Object for setting up fileuploader on a parsenip input.
 */
parsenip.uploader = {
  confirmation: null,
  $parsenip: null,
  $input: null,
  upload: null,
  id: null,
  init: function($parsenip) {
    this.$parsenip = $parsenip;
    var $input = this.$parsenip.find(':input');
    this.id = $input.attr('id');
    this.watch();
  },
  complete: function(){
    return !!(this.confirmation && this.confirmation.complete);
  },
  /*
   * Watch the file input until it becomes visible.
   */
  watch: function() {
    var ready = $('#'+this.id+ ':visible').length > 0;
    if( ready ){
      this.set_input();
      this.initialize_uploader();
    }
    else{
      var _this = this;
      setTimeout(function(){
        _this.watch();
      }, 250);
    }
  },
  set_input: function(){
    this.$input = $('#'+this.id);
    this.$container = this.$input.closest('.input-container');
  },
  disable: function() {
    this.$container.addClass('disabled');
    this.$input.attr('disabled', 'disabled');
  },
  start_uploading: function() {
    this.disable();
    this.$container.hide();
    this.show_spinner();
    parsenip.callbacks.upload_started(this);
  },
  show_spinner: function() {
    this.get_spinner().removeClass('hidden');
  },
  hide_spinner: function() {
    this.get_spinner().addClass('hidden');
  },
  get_spinner: function(){
    return this.$container.closest('form').find('.spinner');
  },
  finish_uploading: function(data) {
    var _this = this;
    this.upload = $.extend({}, parsenip.upload);
    this.upload.token = data.result.upload_token;
    this.upload.on_detection(function() {
      _this.show_confirmation(data);
    });
    parsenip.callbacks.upload_finished(this);
  },
  show_confirmation: function(matches, sample, available_columns) {
    this.hide_spinner();
    this.$parsenip.find('.parsenip-upload').addClass('hidden');
    this.confirmation = $.extend({}, parsenip.confirmation);
    this.confirmation.init(this.$parsenip, this.upload);
    parsenip.callbacks.show_confirmation(this.confirmation);
  },
  initialize_uploader: function() {
    var _this = this;
    this.$input.fileupload({
      formData: {callback_url: parsenip.config.callback_url},
      dataType: 'json',
      add: function (e, data) {
        _this.start_uploading();
        data.submit();
      },
      done: function (e, data) {
        _this.finish_uploading(data);
      }
    });
  }
};

/*
 * Object for handling uploads (storing the token locally, etc.)
 */
parsenip.upload = {
  token: null,
  matches: null,
  sample: null,
  available_columns: null,
  on_detection: function(callback) {
    var _this = this;
    setTimeout(function(){
      $.get(parsenip.url.matches(parsenip.config, _this), function(data){
        if(data.complete) {
          _this.matches = data.matches;
          _this.sample = data.sample;
          _this.available_columns = data.available_columns;
          callback.call();
        } else {
          _this.on_detection(callback);
        }
      });
    }, 250)
  }
};

/*
 * Object for handling the confirmation step.
 */
parsenip.confirmation = {
  complete: false,
  $parsenip: null,
  $results: null,
  matches: null,
  sample: null,
  available_columns: null,
  upload: null, // the upload object
  init: function($parsenip, upload){
    this.$parsenip = $('#' + $parsenip.attr('id'));
    this.$results  = this.$parsenip.find('.confirmation-results');
    this.upload    = upload;
    this.matches   = this.upload.matches;
    this.sample    = this.upload.sample;
    this.available_columns = this.upload.available_columns;
    this.show_detected_data();
  },
  show_detected_data: function() {
    var $form = $('<form>');
    var $table = $('<table>');
    $table.addClass('table table-striped');
    var _this = this;

    var $header_row = $('<tr>');
    $.each(this.matches, function(key, column){
      var $cell = $('<th>');

      var $select = $('<select>').attr('name', "upload[columns][]");
      $select.append($('<option>').val('').text(''));
      $.each(_this.available_columns, function(i, column_option){
        var column_option_name = column_option.name;
        var $option = $('<option>').text(column_option_name).val(column_option.key);
        if( column == column_option.key ){
          $option.attr('selected', 'selected');
        }
        $select.append($option);
      });
      $cell.append($select);

      $header_row.append($cell);
    });
    $table.append($header_row);

    $.each(this.sample, function(i, contact){
      var $row = $('<tr>');
      $.each(_this.matches, function(key, column){
        var $cell = $('<td>');
        if( contact[key] ) {
          $cell.text(contact[key]);
        }
        $row.append($cell);
      });
      $table.append($row);
    });

    $form.append($table);
    var $confirm = $('<input>').attr('type', 'submit').val('Confirm fields and import data').addClass('btn btn-success confirm-button');
    $form.on('submit', function(ev){
      _this.send_confirmation_data(ev);
      _this.complete = true;
    });
    $form.append($confirm);
    $form.append(parsenip.helper.spinner.setup());
    this.$results.append($form);
  },
  hide_results: function() {
    this.$results.find('.confirm-button').addClass('hidden');
    this.$results.find('.spinner').removeClass('hidden');
  },
  hold_until_import_success: function(complete_function) {
    var _this = this;
    parsenip.callbacks.pending_local_completion(_this.upload,
      function() { complete_function.call(_this); }
    );
  },
  import_complete: function() {
    this.$results.addClass('hidden');
    this.show_thank_you();
    this.complete = true;
    parsenip.callbacks.import_finished(this.$parsenip);
  },
  show_thank_you: function() {
    parsenip.thankyou.init(this.$parsenip);
  },
  send_confirmation_data: function(ev) {
    ev.preventDefault();
    var _this = this;
    this.hide_results();
    $.post(parsenip.url.confirm(parsenip.config, this.upload),
      this.$results.find('form').serialize(),
      function(result){
        if(result.success) {
          parsenip.callbacks.confirmation_sent(_this);
          _this.hold_until_import_success(function() {
            this.import_complete();
          });
        }
      });
  }
};

parsenip.thankyou = {
  $parsenip: null,
  init: function($parsenip) {
    this.$parsenip = $parsenip;
    this.$parsenip.find('.thankyou').removeClass('hidden');
  }
};

parsenip.helper = {};
parsenip.helper.spinner = {
  setup: function() {
    var $spinner = $('<span>').addClass('spinner').addClass('hidden');
    $spinner.append($('<span>').addClass('spin'));
    return $spinner;
  }
};
parsenip.helper.string = {
  humanize: function(string) {
    return this.upcase_first( string.replace(/_/g, ' ') );
  },
  upcase_first: function(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  },
  generate_uuid: function() {
    return parseInt(Math.random() * 100000000000).toString(16);
  }
};

/*
 * Callbacks for Parsenip that can be hooked into for custom integration.
 */
parsenip.callbacks = {
  form_construction_complete: function($parsenip) { },
  upload_started: function(uploader) { },
  upload_finished: function(uploader) { },
  show_confirmation: function(confirmation) { },
  confirmation_sent: function(uploader) { },
  pending_local_completion: function(upload, complete_function) {
    /*
     * Default behavior is to instantly declare completion, since there is no
     * way to guess that the import is completed.
     */
    complete_function.call();
  },
  import_finished: function($parsenip) {},
  reset: function() { }
};

parsenip.text = {
  import_thankyou:  "Thank you!  Your contact data has been imported successfully."
};

$(document).on('ready page:load page:change', function() {
  parsenip.initialize_all();
});

