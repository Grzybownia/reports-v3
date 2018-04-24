            var vm = new ActionModel
            {
                BaseData = new ActionBaseDataModel
                {
                    ActionNumber = actionMainData.ActionNumber,
                    ActionTypeDictId = actionMainData.ActionType.DictionaryItemId,
                    DirectionTypeDictId = shippingOperationMainData.Direction.DictionaryItemId,
                    RelationTypeDictId = shippingOperationMainData.RelationType?.DictionaryItemId,
                    OperationTypeDictId = shippingOperationMainData.OperationType.DictionaryItemId,
                    ActionId = shippingAction.ShippingActionId,
                    ActionType = shippingAction.ActionType?.Name,
                    ActionTypeId = shippingAction.ActionType.DictionaryItemVersionId,
                    ShippingOperationId = shippingOperation.ShippingOperationId,
                    ShippingOperationMainId = shippingOperationMainData.ShippingOperationMainDataId,
                    OperationNumber = shippingOperationMainData.OperationNumber,
                    ActionMainId = actionMainData.ShippingActionMainDataId,
                    CreateDate = actionMainData.CreatedDate,
                    CreatedBy = Mapper.Map<SimpleDictionaryItemModel>(actionMainData.CreatedUser),
                    EndDate = shippingAction.EndDate
                },
                Data = new ActionDataModel
                {
                    Contractor = Mapper.Map<SimpleDictionaryItemModel>(shippingAction.Contractor),
                    ContractorOffice = Mapper.Map<OfficeModel>(shippingAction.ContractorOffice),
                    ContractorOfficeManager = Mapper.Map<SimpleDictionaryItemModel>(shippingAction.ContractorOfficeManager),
                    ContractorComments = shippingAction.ContractorComments,
                    CustomerComments = shippingAction.CustomerComments,
                    AcceptanceDate = shippingAction.AcceptanceDate,
                    RealizationDate = shippingAction.RealizationDate,
                    Status = Mapper.Map<SimpleDictionaryItemModel>(shippingAction.ActionStatus),
                    StatusId = shippingAction.ActionStatusId
                },

                CalculationPosition = calcPosition != null ? ShippingOperationCalculationHelper.ConvertEntitesToModel(calcPosition, null) : null
            };