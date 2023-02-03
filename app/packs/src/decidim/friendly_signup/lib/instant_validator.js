/* eslint-disable line-comment-position, no-ternary, no-inline-comments */

// Instant, server-side validation
// compatible with abide classes https://get.foundation/sites/docs/abide.html
export default class InstantValidator {
  // ms before xhr check

  constructor($form) {
    this.$form = $form;
    this.$inputs = $form.find("[data-instant-attribute]");
    this.url = this.$form.data("validationUrl");
    this.TIMEOUT = null;
  }

  init() {
    if (!this.url || !this.$form.length) {
      return;
    }
    this.$form.foundation("disableValidation");
    // this final validation prevents abide from resetting the field when user loses focus
    this.$inputs.on("blur", (evt) => {
      // If it's empty (or not tampered), run the validation
      if (this.value($(evt.target)) === "") {
        this.validate($(evt.target));
      }
    });
    this.$inputs.on("input", (evt) => {
      let $input = $(evt.currentTarget);
      clearTimeout(this.TIMEOUT);
      this.TIMEOUT = setTimeout(() => {
        this.validate($input);
      }, 600);
    });
  }

  value($input) {
    return $input.val().trim();
  }

  attribute($input) {
    return $input.data("instantAttribute");
  }

  target($input) {
    const $target = this.$form.find($input.data("instantTarget"));
    return $target.length
      ? $target
      : $input;
  }

  validate($input) {
    let $recheck = $($input.data("instantRecheck"));
    this.tamper($input);
    this.post($input).done((response) => {
      this.setFeedback(response, $input);
    });

    if ($recheck.length && this.isTampered($recheck)) {
      this.validate($recheck)
    }
  }

  setFeedback(data, $input) {
    if (data.valid) {
      this.clearErrors($input);
    } else {
      this.addErrors(this.target($input), data.error);
    }
  }

  tamper($dest) {
    $dest.data("tampered", $dest.val().trim() !== "");
  }

  isTampered($dest) {
    return $dest.data("tampered");
  }

  addErrors($dest, msg) {
    if ($dest.closest("label").find(".form-error").length > 1) {
      // Decidim may add and additional error class that does not play well with abide
      $dest.closest("label").find(".form-error:last").remove();
    }
    this.$form.foundation("addErrorClasses", $dest);
    if (msg) {
      $dest.closest("label").find(".form-error").html(msg);
    }
  }

  clearErrors($dest) {
    this.$form.foundation("removeErrorClasses", $dest);
  }

  post($input) {
    return $.ajax(this.url, {
      method: "POST",
      data: `${this.$form.serialize()}&attribute=${this.attribute($input)}`
    });
  }
}
