$(() => {
  const $inputs = $('.confirmation-code-inputs input[type="number"]');
  const $form = $inputs.closest("form");
  const intRegex = /^\d+$/;
  let disableManual = false;

  // Parses the individual digits into the individual boxes.
  const pasteValues = (element, $first) => {
    const values = element.split("");
    let $inputBox = $first;

    $(values).each((index) => {
      $inputBox.val(values[index]);
      $inputBox = $inputBox.next('input[type="number"]');
      if ($inputBox.length === 0) {
        $form.submit();
      }
    });
  };

  $inputs.on("focus", (e) => {
    $(e.target).select();
  });

  // Prevents user from manually entering non-digits.
  $inputs.on("input.fromManual", (e) => {
    if (disableManual) {
      return;
    }
    const $this = $(e.target);
    if (intRegex.test($this.val())) {
      pasteValues($this.val(), $this);
      $this.next('input[type="number"]').focus();
    } else {
      $this.val("");
    }
  });

  $inputs.on("paste", (evt) => {
    const $this = $(evt.target);
    const originalValue = $this.val();
    $this.val("");
    disableManual = true;
    $this.one("input.fromPaste", (e) => {
      const $currentInputBox = $(e.target);

      const pastedValue = $currentInputBox.val();
      if (intRegex.test(pastedValue)) {
        pasteValues(pastedValue, $inputs.eq(0));
      }
      else {
        $this.val(originalValue);
      }
      disableManual = false;
    });
  });
});
