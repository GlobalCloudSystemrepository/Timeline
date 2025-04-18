global with sharing class MyTaskTimelineProvider extends timeline.AbstractTimelineDataProvider {

    global override String getObjectName() {
        return 'Task';
    }

    global override String getRelationshipName() {
        return 'Tasks';
    }

    global override String getTitleField() {
        return 'Subject';
    }

    global override String getDateField() {
        return 'ActivityDate';
    }

    global override List<String> getFieldsToDisplay() {
        return new List<String>{ 'Subject', 'CreatedDate', 'ActivityDate', 'IsClosed', 'IsArchived' };
    }

    global override String getBaseUrlForRecordDetail() {
        return '';
    }

    global override String getRecordIdentifierField() {
        return 'Id';
    }

    global override List<Object> getData(Id recordId, String dateFilter) {
        List<Object> results = new List<Object>();

        String soql = 'SELECT Id, Subject, CreatedDate, ActivityDate, IsClosed, IsArchived, Owner.Name, Who.Name ' +
                      'FROM Task WHERE WhatId = \'' + String.escapeSingleQuotes(recordId) + '\' ' +
                      'ORDER BY ActivityDate DESC ALL ROWS';

        List<Task> taskList = (List<Task>) Database.query(soql);

        for (Task t : taskList) {
            Map<String, Object> obj = new Map<String, Object>{
                'Id' => t.Id,
                'Subject' => t.Subject,
                'CreatedDate' => t.CreatedDate,
                'ActivityDate' => t.ActivityDate,
                'IsClosed' => t.IsClosed,
                'IsArchived' => t.IsArchived,
                'Owner' => new Map<String, Object>{ 'Name' => t.Owner != null ? t.Owner.Name : null }
            };
            if (t.WhoId != null) {
                obj.put('Who', new Map<String, Object>{ 'Name' => t.Who != null ? t.Who.Name : null });
            }
            results.add(obj);
        }

        return results;
    }

    global override Boolean isSalesforceObject() { return true; }
    global override Boolean isUiApiNotSupported() { return true; }
}
