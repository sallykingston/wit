var alertNonMember = function(notice){
  switch (notice) {
    case "non-member":
      $("#member-alert").modal('show');
      break;
    case "This area is restricted to members of CHS Women in Tech only.":
      $("#forum-alert").modal('show');
      break;
    default:
  }
};
