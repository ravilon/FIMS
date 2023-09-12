CREATE OR REPLACE FUNCTION create_data_items()
RETURNS TRIGGER AS $$
DECLARE
  param_list_id VARCHAR(30);
  param_item_id VARCHAR(30);
  data_item_id VARCHAR(30);
BEGIN
  -- Get the ParamListId of the new DataSet
  SELECT ParamList INTO param_list_id FROM DataSet WHERE DataSetId = NEW.DataSetId;

  -- Get all ParamItems associated with the ParamList
  FOR param_item_id IN (SELECT ParamId FROM ParamItem WHERE ParamList = param_list_id)
  LOOP
    -- Create a new DataItem for each ParamItem
    INSERT INTO DataItem (DataParamId, DataItemStatus, DataSet)
    VALUES (param_item_id, 'Initial', NEW.DataSetId);
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_data_items_trigger
AFTER INSERT ON DataSet
FOR EACH ROW
EXECUTE FUNCTION create_data_items();